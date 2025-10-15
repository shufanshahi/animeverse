#!/bin/bash

# AnimeVerse Chatbot - CORS Fix Script
# This script runs the Flutter web app with CORS disabled to allow communication with LM Studio

echo "🚀 Starting AnimeVerse with CORS disabled for LM Studio integration..."
echo ""
echo "⚠️  IMPORTANT: Make sure LM Studio is running with a loaded model on localhost:1234"
echo ""
echo "Starting Flutter app..."

# Run Flutter with CORS disabled
flutter run -d chrome --web-browser-flag "--disable-web-security" --web-browser-flag "--disable-features=VizDisplayCompositor"

echo ""
echo "✅ App started! The chatbot should now work with LM Studio."
echo ""
echo "If you still have issues:"
echo "1. Ensure LM Studio server is running on localhost:1234"
echo "2. Load a model in LM Studio"
echo "3. Check that the model is responding in LM Studio's chat interface first"