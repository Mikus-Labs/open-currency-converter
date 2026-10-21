// Redraws the teal calculator icon as vector shapes.
// Usage: swift assets/icon/draw.swift assets/icon/icon.png [height fraction, default 0.74]
// then: dart run flutter_launcher_icons
import AppKit
import CoreText

let out = CommandLine.arguments[1]
let heightFraction = CommandLine.arguments.count > 2 ? Double(CommandLine.arguments[2])! : 0.74
let N = 1024.0

func rgb(_ hex: UInt32) -> CGColor {
  CGColor(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255,
          blue: CGFloat(hex & 0xFF) / 255, alpha: 1)
}
let teal = rgb(0x048389), white = rgb(0xFFFFFF), gold = rgb(0xFFC107), coral = rgb(0xFF7043)

let ctx = CGContext(data: nil, width: Int(N), height: Int(N), bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!,
                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
// Work in top-left coordinates.
ctx.translateBy(x: 0, y: N)
ctx.scaleBy(x: 1, y: -1)

ctx.setFillColor(teal)
ctx.fill(CGRect(x: 0, y: 0, width: N, height: N))

// Calculator geometry in the original drawing's units (body 475 x 642).
let bodyW = 475.0, bodyH = 642.0
let s = heightFraction * N / bodyH
let ox = (N - bodyW * s) / 2, oy = (N - bodyH * s) / 2
func r(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> CGRect {
  CGRect(x: ox + x * s, y: oy + y * s, width: w * s, height: h * s)
}
func roundRect(_ rect: CGRect, _ radius: Double, _ color: CGColor) {
  ctx.setFillColor(color)
  ctx.addPath(CGPath(roundedRect: rect, cornerWidth: radius * s, cornerHeight: radius * s, transform: nil))
  ctx.fillPath()
}

roundRect(r(0, 0, bodyW, bodyH), 52, white)
let display = r(65, 70, 345, 150)
roundRect(display, 14, teal)
for row in 0..<3 {
  for col in 0..<3 {
    roundRect(r(65 + Double(col) * 132, 280 + Double(row) * 105, 81, 81), 12, teal)
  }
}

// Display contents: gold $, white ⇄, coral €.
func glyph(_ text: String, centerX: Double, color: CGColor) {
  let font = CTFontCreateWithName("SFProRounded-Heavy" as CFString, 118 * s, nil)
  let fallback = NSFont.systemFont(ofSize: 118 * s, weight: .heavy)
  let useFont: CTFont = CTFontCopyPostScriptName(font) as String == "SFProRounded-Heavy" ? font : fallback
  let attr = NSAttributedString(string: text, attributes: [
    NSAttributedString.Key(kCTFontAttributeName as String): useFont,
    NSAttributedString.Key(kCTForegroundColorAttributeName as String): color,
  ])
  let line = CTLineCreateWithAttributedString(attr)
  let bounds = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
  ctx.saveGState()
  // Text draws upright in a flipped context only with a flipped text matrix.
  ctx.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
  let cx = display.minX + centerX * s, cy = display.midY
  ctx.textPosition = CGPoint(x: cx - bounds.midX, y: cy + bounds.midY)
  CTLineDraw(line, ctx)
  ctx.restoreGState()
}
glyph("$", centerX: 68, color: gold)
glyph("€", centerX: 277, color: coral)

// ⇄ drawn as two arrows so it matches the glyph weight.
func arrow(y: Double, pointingRight: Bool) {
  let cx = display.minX + 172.5 * s, cy = display.midY + y * s
  let half = 44.0 * s, bar = 7.5 * s, headLen = 26.0 * s, headHalf = 21.0 * s
  let d: Double = pointingRight ? 1 : -1
  let tip = cx + d * half, base = cx + d * (half - headLen), tail = cx - d * half
  let p = CGMutablePath()
  p.move(to: CGPoint(x: tail, y: cy - bar))
  p.addLine(to: CGPoint(x: base, y: cy - bar))
  p.addLine(to: CGPoint(x: base, y: cy - headHalf))
  p.addLine(to: CGPoint(x: tip, y: cy))
  p.addLine(to: CGPoint(x: base, y: cy + headHalf))
  p.addLine(to: CGPoint(x: base, y: cy + bar))
  p.addLine(to: CGPoint(x: tail, y: cy + bar))
  p.closeSubpath()
  ctx.setFillColor(white)
  ctx.addPath(p)
  ctx.fillPath()
}
arrow(y: -22, pointingRight: true)
arrow(y: 22, pointingRight: false)

let image = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: image)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print("wrote \(out), calculator \(Int(bodyW * s))x\(Int(bodyH * s))")
