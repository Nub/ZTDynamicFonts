Pod::Spec.new do |s|
  s.name         = "ZTDynamicFonts"
  s.version      = "0.3"
  s.summary      = "Lightweight tool to define custom fonts and styles for dynamic type text sizing via Settings.app"
  s.homepage     = "https://github.com/Nub/ZTDynamicFonts"
  s.license      = 'MIT'
  s.author       = { "Zachry Thayer" => "zachthayer@gmail.com" }
  s.source       = { :git => "https://github.com/Nub/ZTDynamicFonts.git"}

  s.source_files = 'UIFont+ZTDynamicFonts.?'
  s.requires_arc = true
end

