#! /bin/bash
echo "🔍 Checking for XCode Select..."
xcode-select -p &>/dev/null
if [[ $? != 0 ]] ; then
    echo "⏳ Installing XCode Select..."
    xcode-select --install
    echo "✅ XCode Select installed"
else
    echo "✅ XCode Select found"
fi