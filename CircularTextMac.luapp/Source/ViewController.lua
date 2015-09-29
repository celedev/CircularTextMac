-- Class extension of native class ViewController
local TextView = require "TextView"

local codeUpdatedMessage = "ViewController code updated "

local ViewController = class.extendClass(objc.ViewController)

function ViewController:viewDidLoad ()
    self[ViewController.superclass]:viewDidLoad()
    self:promoteAsLuaObject()
end

function ViewController:promoteAsLuaObject()
   if self.isViewLoaded then
       self:configureView()
       -- Re-configure the controller's view when the code is updated
       self:addMessageHandler(codeUpdatedMessage, 'configureView')
   end
end

local NSLayoutConstraint = objc.NSLayoutConstraint

function ViewController:configureView()
    
    -- remove existing subviews
    self.view:setSubviews {}
    
    local viewBounds = self.view.bounds
        
    -- Add a circle text view
    local textView = TextView:newWithFrame(viewBounds)
    self.view:addSubview(textView)
    
    -- Set layout constraints for the circle view
    textView.translatesAutoresizingMaskIntoConstraints = false
    self.view:addConstraints (NSLayoutConstraint:constraintsWithVisualFormat_options_metrics_views
                                                 ("|-0-[textView]-0-|", 0, nil, { textView = textView }))
    self.view:addConstraints (NSLayoutConstraint:constraintsWithVisualFormat_options_metrics_views
                                                 ("V:|-0-[textView]-0-|", 0, nil, { textView = textView }))
    
    -- Set some text in the circle text view
    getResource ("TextLine", "rtf", textView, "text");
end

message.post (codeUpdatedMessage)

return ViewController