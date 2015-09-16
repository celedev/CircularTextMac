-- Class HelloTextView

local NSTextStorage = objc.NSTextStorage
local NSLayoutManager = objc.NSLayoutManager
local NSTextContainer = objc.NSTextContainer

local NSColor = objc.NSColor
local NSRange = struct.NSRange
local CGPoint = struct.CGPoint

local CgContext = require "CoreGraphics.CGContext"
local CgAffineTransform = require "CoreGraphics.CGAffineTransform"
local NSGraphicsContext = objc.NSGraphicsContext

local TextView = class.createClass("TextView", objc.NSView)

function TextView:initWithFrame (frame)
    
    self[TextView.superclass]:initWithFrame(frame)
    self.opaque = false
    self.userInteractionEnabled = false
    
    self:addMessageHandler ("CircleTextView updated", "refresh")
end

function TextView:setText (attributedString)
    
    if self.textContainer == nil then
        -- Create the text system for this view
        local textStorage = NSTextStorage:new()
        local layoutManager = NSLayoutManager:new()
        textStorage:addLayoutManager(layoutManager)
        
        -- Create a text container with a very large width
        local textContainer = NSTextContainer:newWithSize(struct.CGSize(100000, 50))
        layoutManager:addTextContainer(textContainer)
        
        self.textContainer = textContainer
        self.textStorage = textStorage
        self.layoutManager = layoutManager
    end
       
    self.textStorage:setAttributedString(attributedString)
    self:setNeedsDisplay(true)
end

local startingAngle =  - math.pi / 2
local glyphsSpacingFactor = 1.3

function TextView:drawRect(rect)
    
    if (self.textStorage ~= nil) and (self.textStorage.length > 0) then
        
        local bounds = self.bounds
        local center = { x = bounds:getMidX(), y = bounds:getMidY() }
        local radius = math.min (bounds.size.width, bounds.size.height) / 2
        
        -- Trigger the text layout if needed
        local lineRect, glyphRange = self.layoutManager:lineFragmentUsedRectForGlyphAtIndex_effectiveRange(0)
        
         local ctx = objc.NSGraphicsContext.currentContext.CGContext
        
        NSColor.whiteColor:setFill()
        CgContext.FillRect(ctx, rect)
        
        self.layoutManager:drawGlyphsForGlyphRange_atPoint(glyphRange, CGPoint(center.x - lineRect.size.width / 2,
                                                                               center.y - lineRect.size.height / 2))
        
        local startAngleOffset = startingAngle
        local deltaRadius = 0
        
        do
            local glyphAngle
            
            -- Draw each glyph on the circle
            for glyphIndex = glyphRange.location, glyphRange:maxLocation() - 1 do
                
                local glyphLocation = self.layoutManager:locationForGlyphAtIndex(glyphIndex)
                local distance = radius - glyphLocation.y + deltaRadius
                glyphAngle = startAngleOffset - 
                             (glyphsSpacingFactor * glyphLocation.x) / distance
                
                -- Create a spiral effect by making the distance depend on the angle
                -- deltaRadius = (glyphAngle - startingAngle) * 4
                
                local transform = CgAffineTransform.Identity
                transform = transform:translate (center.x + distance * math.sin(glyphAngle),
                                                 center.y + distance * math.cos(glyphAngle))
                transform = transform:rotate (math.pi - glyphAngle)
                
                CgContext.SaveGState(ctx)
                CgContext.ConcatCTM(ctx, transform)
                
                self.layoutManager:drawGlyphsForGlyphRange_atPoint (NSRange(glyphIndex, 1), 
                                                                    CGPoint(-(lineRect.origin.x + glyphLocation.x),
                                                                            -(lineRect.origin.y + glyphLocation.y)))
                
                CgContext.RestoreGState(ctx)                
            end
            
            startAngleOffset = glyphAngle
        end
    end
end

TextView:declareSetters { text = TextView.setText }

function TextView:refresh ()
    self:setNeedsDisplay(true)
end

message.post ("CircleTextView updated")

return TextView
