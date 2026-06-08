local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Top 8 NEEDED Morphs v1",
   Icon = 0,
   LoadingTitle = "Loading UI...",
   LoadingSubtitle = "by NotAHacker11294",
   ShowText = "Morph UI",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "NotAHacker11294 Morph Hub v1"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Morphs")

Rayfield:Notify({
   Title = "Thank You",
   Content = "For using my Morph UI v1",
   Duration = 6.5,
})

local Button = MainTab:CreateButton({
   Name = "Mobile Keyboard",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox-HttpSpy/Random-Silly-stuff/refs/heads/main/Utils/keyboard.luau"))()
   end,
})

