-- Add custom key inputs for advanced logistics system

data:extend({
  {
    type = "custom-input",
    name = "ls-toggle-gui",
    key_sequence = "L"
  },
  {
    type = "custom-input",
    name = "ls-close-gui",
	consuming = "game-only",
    key_sequence = "SHIFT + ESCAPE"
  }
})