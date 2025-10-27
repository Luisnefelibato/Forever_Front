#!/bin/bash

# Script to generate all necessary code for ForeverUsInLove
# This includes JSON serialization and Retrofit API clients

echo "🚀 Generating code for ForeverUsInLove..."
echo ""

# Clean previous generated files
echo "🧹 Cleaning previous generated files..."
flutter pub run build_runner clean

echo ""
echo "⚙️  Generating new files..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ Code generation complete!"
echo ""
echo "Generated files:"
echo "  - JSON Serialization (*.g.dart)"
echo "  - Retrofit API Clients (*.g.dart)"
echo ""
echo "📝 Note: Run this script whenever you:"
echo "  - Add new @JsonSerializable() models"
echo "  - Add new @RestApi() clients"
echo "  - Modify existing models or API endpoints"
