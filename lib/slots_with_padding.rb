# Override :stack and :flow to support a :padding style. 
# Implementation requires that you supply background as a style.
module SlotsWithPadding
  def stack(options = {}, &block)
    if padding = options.delete(:padding)
      super options do
        background options[:background] if options[:background]
        super options.merge(:margin => padding), &block
      end
    else
      super
    end
  end
  
  def flow(options = {}, &block)
    if padding = options.delete(:padding)
      stack options do
        background options[:background] if options[:background]
        super options.merge(:margin => padding), &block
      end
    else
      super
    end
  end
end
