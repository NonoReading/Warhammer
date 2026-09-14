param(
  [string]$XmlPath = "C:\Users\arnau\Documents\Lazarus Project\Warhammer\DATABASE\WFRP5\BOOK_RULESBOOK.Xml",
  [string]$OutPath = "C:\Users\arnau\Documents\Lazarus Project\Warhammer\Audit_Trapping_Carrieres.xlsx"
)

$content = Get-Content -Raw -Encoding UTF8 $XmlPath

function Build-CatalogMap($content, $blockTag, $itemTag) {
  $map = @{}
  if ($content -match "<$blockTag>(?s)(.*?)</$blockTag>") {
    $block = $Matches[1]
    $entryMatches = [regex]::Matches($block, "<$itemTag id=`"([^`"]+)`">\s*<Description language=`"ENGLISH`">`"([^`"]*)`"")
    foreach ($e in $entryMatches) {
      $map[$e.Groups[1].Value] = $e.Groups[2].Value
    }
  }
  return $map
}

Write-Output "Building catalog maps..."
$weaponMap   = Build-CatalogMap $content "DATA_WEAPON" "Weapon"
$armorMap    = Build-CatalogMap $content "DATA_ARMOR" "Armor"
$trappingMap = Build-CatalogMap $content "DATA_TRAPPING" "Trapping"
Write-Output ("Weapon:{0}  Armor:{1}  Trapping:{2}" -f $weaponMap.Count, $armorMap.Count, $trappingMap.Count)

function Resolve-Label($code) {
  if ($weaponMap.ContainsKey($code))   { return $weaponMap[$code] }
  if ($armorMap.ContainsKey($code))    { return $armorMap[$code] }
  if ($trappingMap.ContainsKey($code)) { return $trappingMap[$code] }
  return $null
}

$rows = New-Object System.Collections.Generic.List[object]

$careerMatches = [regex]::Matches($content, '(?s)<Career id="([^"]+)">\s*<Description language="ENGLISH">"([^"]*)".*?<SUBCHAPTER_ITEM>(.*?)</SUBCHAPTER_ITEM>')
Write-Output ("Careers found: {0}" -f $careerMatches.Count)

foreach ($c in $careerMatches) {
  $codeMetier = $c.Groups[1].Value
  $metier     = $c.Groups[2].Value
  $itemBlock  = $c.Groups[3].Value

  $itemMatches = [regex]::Matches($itemBlock, '<Item name="([^"]+)"(?:\s+quantite="(\d+)")?>"([^"]*)"</Item>')
  foreach ($im in $itemMatches) {
    $rawName  = $im.Groups[1].Value
    $quantite = $im.Groups[2].Value
    $niveau   = $im.Groups[3].Value

    $tokens = $rawName -split '[\+/]'
    foreach ($tok in $tokens) {
      $tok = $tok.Trim()
      $trapping = ""
      if ($tok -match '^RULES-') {
        $lbl = Resolve-Label $tok
        if ($null -ne $lbl) { $trapping = $lbl } else { $trapping = "NON RESOLU" }
      }
      $texteOrigine = $tok
      if ($quantite -ne "") { $texteOrigine = "$tok (x$quantite)" }

      $rows.Add([PSCustomObject]@{
        "Code metier"  = $codeMetier
        "Metier"       = $metier
        "Niveau"       = $niveau
        "Trapping"     = $trapping
        "Texte origine"= $texteOrigine
      })
    }
  }
}

Write-Output ("Total rows: {0}" -f $rows.Count)

if (Test-Path $OutPath) { Remove-Item $OutPath -Force }
$rows | Export-Excel -Path $OutPath -WorksheetName "Audit Trapping" -AutoSize -FreezeTopRow -BoldTopRow -AutoFilter -TableStyle Medium2

Write-Output "Written to $OutPath"
