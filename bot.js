const express = require("express");
const { Client, GatewayIntentBits } = require("discord.js");
const cors = require("cors");
const axios = require("axios");
const http = require("http");
const { Server } = require("socket.io");
const { text } = require("stream/consumers");
const { channel } = require("diagnostics_channel");

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server);

const PORT = process.env.PORT || 3000;

const sentMessagesc = new Set();

app.use(express.static("public"));

io.on("connection", (socket) => {
  console.log("user connected");
});

// 🔴 Discord bot
const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent
  ]
});


client.login(process.env.TOKEN);

// 📦 เก็บข้อมูล
let data = {};

// 📥 Discord message (เหลืออันเดียวพอ)
client.on("messageCreate", (message) => {

  if (sentMessages.has(message.id)) return;
  sentMessages.add(message.id);
  
  if (message.author.bot) return;
  if (!message.guild) return;

  const channelId = message.channel.id;

  console.log("ห้อง:", channelId);
  console.log("ข้อความ:", message.content);

  if (!data[channelId]) {
    data[channelId] = [];
  }

  let msgData = {
    user: message.author.username,
    text: message.content,
    images: [],
    videos: []
  };

  // รูป / วิดีโอ (FIXED)
  if (message.attachments.size > 0) {
    message.attachments.forEach(att => {
      const url = att.url;

      if (!url) return;

      // 🔥 ตรวจจาก extension แทน (ชัวร์กว่า)
      if (url.match(/\.(mp4|mov|webm)$/i)) {
        msgData.videos.push(url);
      }
      else if (url.match(/\.(png|jpg|jpeg|gif|webp)$/i)) {
        msgData.images.push(url);
      }
      else {
        // fallback กันพลาด
        msgData.images.push(url);
      }
    });
  }
  axios.post("https://discord-mheg.onrender.com/api/message", {
    user: msgData.user,
    text: msgData.text,
    channelId: channelId,
    images: msgData.images,
    videos: msgData.videos
  }).catch(() => { });

  data[channelId].push(msgData);

  console.log("บันทึก:", msgData);
});

// 📡 READY โหลดย้อนหลัง

client.on("ready", async () => {
  console.log("กำลังล้างข้อมูลเก่า...");

  // 🔥 ล้างก่อน
  await axios.get("https://discord-mheg.onrender.com/reset");

  console.log("กำลังโหลดทุกห้อง...");

  const channels = client.channels.cache;

  for (const [id, channel] of channels) {
    if (!channel.isTextBased()) continue;

    try {
      const messages = await channel.messages.fetch({ limit: 100 });

      messages.forEach(message => {
        const channelId = message.channel.id;

        if (sentMessages.has(message.id)) return;
        sentMessages.add(message.id);

        let msgData = {
          id: message.id, // 🔥 เพิ่มกันซ้ำ
          user: message.author.username,
          text: message.content,
          images: [],
          videos: []
        };

        message.attachments.forEach(att => {
          if (att.contentType && att.contentType.startsWith("image")) {
            msgData.images.push(att.url);
          } else if (att.contentType && att.contentType.startsWith("video")) {
            msgData.videos.push(att.url);
          }
        });

        axios.post("https://discord-mheg.onrender.com/api/message", {
          user: msgData.user,
          text: msgData.text,
          channelId: channelId,
          images: msgData.images,
          videos: msgData.videos
        }).catch(() => { });
      });

      console.log("โหลดห้อง:", channel.name);
    } catch (err) {
      console.log("ข้ามห้อง:", channel.name);
    }
  }

  console.log("โหลดทุกห้องเสร็จแล้ว!");
});

// 🌐 API ดึงข้อความ
app.get("/messages/:channelId", (req, res) => {
  const id = req.params.channelId;
  res.json(data[id] || []);
});

// ▶️ server (Render)
server.listen(PORT, () => {
  console.log("Server running on port " + PORT);
});
