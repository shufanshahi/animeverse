# 🤖 AnimeVerse Chatbot Setup Guide

## Overview
The AnimeVerse app includes an AI-powered chatbot that can answer questions about anime using LM Studio for local AI inference.

## Prerequisites

### 1. Install LM Studio
1. Download LM Studio from: https://lmstudio.ai/
2. Install and launch LM Studio
3. Download a compatible model (recommended: any 7B or 13B chat model)

### 2. Setup LM Studio
1. **Load a Model:**
   - Open LM Studio
   - Go to the "Chat" tab
   - Click "Select a model to load"
   - Choose a model you've downloaded
   - Click "Load Model"

2. **Start the Server:**
   - Go to the "Developer" tab in LM Studio
   - Click "Start Server"
   - Ensure it's running on `localhost:1234`
   - You should see: "Server is running on http://localhost:1234"

## Running the AnimeVerse App

### Option 1: Using the Script (Recommended)
```bash
./run_with_cors_fix.sh
```

### Option 2: Manual Command
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### Option 3: Desktop App (No CORS Issues)
```bash
flutter run -d linux    # or windows/macos
```

## Troubleshooting

### ❌ "LM Studio server is not running"
- **Solution:** Start LM Studio and ensure the server is running on localhost:1234

### ❌ "No model loaded in LM Studio"
- **Solution:** Load a model in LM Studio's Chat tab before using the chatbot

### ❌ "CORS error detected"
- **Solution:** Run the app with CORS disabled using the script or manual command above

### ❌ Connection issues
1. Check LM Studio console for errors
2. Ensure no firewall is blocking localhost:1234
3. Try restarting LM Studio
4. Verify the model is responding in LM Studio's chat interface first

## Using the Chatbot

1. **Launch the app** and navigate to the home screen
2. **Look for the floating chat button** (bottom-right corner)
   - 🟢 Green = Connected to LM Studio
   - 🔴 Red dot = Not connected
3. **Tap the chat button** to open the chat interface
4. **Ask anime questions** like:
   - "What's the best anime for beginners?"
   - "Tell me about Attack on Titan"
   - "Recommend anime similar to Naruto"
   - "Who are the main characters in One Piece?"

## Features

- ✅ **Real-time AI responses** powered by your local LM Studio model
- ✅ **Connection status indicator** shows when LM Studio is ready
- ✅ **Conversation memory** maintains chat history within the session  
- ✅ **Specialized anime knowledge** with system prompts optimized for anime discussions
- ✅ **Beautiful UI** with smooth animations and message bubbles
- ✅ **Error handling** with helpful troubleshooting messages

## Model Recommendations

For best results, use these types of models:
- **Chat/Instruct models** (better for conversations)
- **7B-13B parameters** (good balance of speed and quality)
- **Examples:**
  - Llama 2 7B Chat
  - Mistral 7B Instruct
  - CodeLlama 7B Instruct
  - Any fine-tuned chat model

Enjoy chatting with your anime AI assistant! 🎌✨