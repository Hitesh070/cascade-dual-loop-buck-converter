$pptxPath = (Get-Item "Cascade_Buck_Converter_Review1_Presentation.pptx").FullName
$outputDir = Join-Path (Get-Location).Path "slide_images"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir }
$ppt = New-Object -ComObject PowerPoint.Application
$pres = $ppt.Presentations.Open($pptxPath, 1, 0, 0)
$pres.SaveAs($outputDir, 17)
$pres.Close()
$ppt.Quit()
Write-Host "Exported slide images successfully to $outputDir"
