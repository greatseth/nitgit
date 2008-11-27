class LabeledCheck < Shoes::Widget
  def initialize text, options = {}, &block
    style :width => options.delete(:width)
    @check = check &block
    para text, options
    click { @check.checked = !@check.checked?; block.call }
  end
  
  def method_missing m,*a,&b
    if @check.respond_to? m
      @check.send m, *a, &b
    else
      super
    end
  end
end
