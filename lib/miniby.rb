# Self-validating markup language
module Miniby
  def self.as_key_hash(ary)
    ary.inject({}) do |hash, key|
      hash[key.to_sym] = true
      hash
    end
  end
  EventHandlerAttributes = %w[onabort onblur oncanplay oncanplaythrough onchange onclick oncontextmenu oncuechange ondblclick ondrag ondragend ondragenter ondragleave ondragover ondragstart ondrop ondurationchange onemptied onended onerror onfocus oninput oninvalid onkeydown onkeypress onkeyup onload onloadeddata onloadedmetadata onloadstart onmousedown onmousemove onmouseout onmouseover onmouseup onmousewheel onpause onplay onplaying onprogress onratechange onreadystatechange onreset onscroll onseeked onseeking onselect onshow onstalled onsubmit onsuspend ontimeupdate onvolumechange onwaiting]
  GlobalAttributes = %w[accesskey class contenteditable contextmenu dir draggable dropzone hidden id lang spellcheck style tabindex title]

  MetadataContent =    %w[base command link meta noscript script style title]
  StyleContent =       %w[a abbr address area article aside audio b bdi bdo blockquote br button canvas cite code command datalist del details dfn div dl em embed fieldset figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr i iframe img input ins kbd keygen label map mark math menu meter nav noscript object ol output p pre progress q ruby s samp script section select small span strong style sub sup svg table textarea time ul var video wbr]
  SectioningContent =  %w[article aside nav section]
  HeadingContent =     %w[h1 h2 h3 h4 h5 h6 hgroup]
  PhrasingContent =    %w[a abbr area audio b bdi bdo br button canvas cite code command datalist del dfn em embed i iframe img input ins kbd keygen label map mark math meter noscript object output progress q ruby s samp script select small span strong sub sup svg textarea time var video wbr]
  EmbeddedContent =    %w[audio canvas embed iframe img math object svg video]
  InteractiveContent = %w[a audio button details embed iframe img input keygen label menu object select textarea video]

  ElementAttributes = {
    :html     => %w[manifest],
    :head     => [],
    :title    => [],
    :base     => %w[href target],
    :link     => %w[href rel media hreflang type sizes],
    :meta     => %w[name http-equiv content charset],
    :style    => %w[media type scoped],
    :script   => %w[src async defer type charset],
    :noscript => [],
    :body     => %w[onafterprint onbeforeprint onbeforeunload onblur onerror onfocus onhashchange onload onmessage onoffline ononline onpagehide onpageshow onpopstate onredo onresize onscroll onstorage onundo onunload],
    :section  => [],
    :nav      => [],
    :article  => [],
    :aside    => [],
    :h1       => [],
    :h2       => [],
    :h3       => [],
    :h4       => [],
    :h5       => [],
    :h6       => [],
    :hgroup   => [],
    :header   => [],
    :footer   => [],
    :address  => [],
    :p        => [],
    :hr       => [],
    :pre      => [],
    :blockquote => %w[cite],
    :ol       => %w[reversed start type],
    :ul       => [],
    :li       => [],
    :dl       => [],
    :dd       => [],
    :figure   => [],
    :figcaption => [],
    :div      => [],
    :a        => %w[href target rel media hreflang type],
    :em       => [],
    :strong   => [],
    :small    => [],
    :s        => [],
    :cite     => [],
    :q        => %w[cite],
    :dfn      => [],
    :abbr     => [],
    :time     => %w[datetime pubdate],
    :code     => [],
    :var      => [],
    :samp     => [],
    :kbd      => [],
    :sub      => [],
    :sup      => [],
    :i        => [],
    :b        => [],
    :mark     => [],
    :ruby     => [],
    :rt       => [],
    :rp       => [],
    :bdi      => [],
    :bdo      => [],
    :span     => [],
    :br       => [],
    :wbr      => [],
    :ins      => %w[cite datetime],
    :del      => %w[cite datetime],
    :img      => %w[alt src usemap ismap width height],
    :iframe   => %w[src srcdoc name sandbox seamless width height],
    :embed    => %w[src type width height],
    :object   => %w[data type name usemap form width height],
    :param    => %w[name value],
    :video    => %w[src poster preload autoplay loop audio controls width height],
    :audio    => %w[src preload autoplay loop controls],
    :source   => %w[src type media],
    :track    => %w[kind src srclang label default],
    :canvas   => %w[width height],
    :map      => %w[name],
    :area     => %w[alt coords shape href target rel media hreflang type],
    :table    => %w[summary],
    :caption  => [],
    :colgroup => %w[span],
    :col      => %w[span],
    :tbody    => [],
    :thead    => [],
    :tfoot    => [],
    :tr       => [],
    :td       => %w[colspan rowspan headers],
    :th       => %w[colspan rowspan headers scope],
    :form     => %w[accept-charset action autocomplete enctype method name novalidate target],
    :fieldset => %w[disabled form name],
    :legend   => [],
    :label    => %w[form for],
    :input    => %w[accept alt autocomplete autofocus checked dirname disabled form formaction formenctype formmethod formnovalidate formtarget height list max maxlength min multiple name pattern placeholder readonly required size src step type value width],
    :button   => %w[autofocus disabled form formaction formenctype formmethod formnovalidate formtarget name type value],
    :select   => %w[autofocus disabled form multiple name required size],
    :datalist => [],
    :optgroup => %w[disabled label],
    :option   => %w[disabled label selected value],
    :textarea => %w[autofocus cols dirname disabled form maxlength name placeholder readonly required rows wrap],
    :keygen   => %w[autofocus challenge disabled form keytype name],
    :output   => %w[for form name],
    :progress => %w[value max form],
    :meter    => %w[value min max low high optimum form],
    :details  => %w[open],
    :command  => %w[type label icon disabled checked radiogroup],
    :menu     => %w[type label],
    :math     => [],
    :svg      => [],
  }
  ElementAttributes.each_pair do |key, val|
   ElementAttributes[key] = (GlobalAttributes + val).map(&:to_sym)
  end

  SELF_CLOSING_TAGS = %w[base link meta hr br wbr img embed param source track area col input keygen command].map(&:to_sym)

  BOOLEAN_ATTRIBUTES = %w[checked disabled selected required scoped async defer autoplay loop scoped reversed pubdate ismap seamless controls readonly multiple autofocus novalidate formnovalidate open hidden truespeed]
  BOOLEAN_ATTRIBUTES_HASH = as_key_hash BOOLEAN_ATTRIBUTES

  # TODO: treat the data-* attribute specially

  class BuildError < StandardError; end

  class FastHtml
    SANE_TAGS = ElementAttributes.keys - [:meter, :defaults, :command, :ruby, :base]
    def initialize(&block)
      @_out = []
      @_current = @_out
      instance_eval(&block) if block_given?
    end

    def text!(txt)
      @_current << txt
      self
    end
    alias << text!

    def serialize_attrs(elem, attrs)
      return '' if attrs.nil? || attrs.empty?
      ([nil] + attrs.map do |xy|
        key, val = *xy
        val = key if BOOLEAN_ATTRIBUTES_HASH[key.to_sym]
        "#{key.to_s.gsub('_','-')}=\"#{val.to_s.gsub('"', '&quot;')}\""
      end).join(' ')
    end

    # symbol === safe
    def escape_html(string)
      str = string ? string.dup : ""
      str.gsub!(/&/n, '&amp;')
      str.gsub!(/\"/n, '&quot;')
      str.gsub!(/>/n, '&gt;')
      str.gsub!(/</n, '&lt;')
      str
    end

    def to_s
      @_out.join
    end

    SANE_TAGS.each do |elem|
      if SELF_CLOSING_TAGS.include? elem
        eval <<-TAGDEF, binding, __FILE__, __LINE__+1
          def #{elem}(attrs = {}, &block)
            railse BuildError, "#{elem} is a self-closing tag" if block_given?
            @_out << "<#{elem}\#{serialize_attrs(#{elem.inspect}, attrs)}>"
            self
          end
        TAGDEF
      else
        eval <<-TAGDEF, binding, __FILE__, __LINE__+1
          def #{elem}(txt = nil, attrs  = nil, &block)
            if attrs.nil? && txt.kind_of?(::Hash)
              txt, attrs = nil, txt
            end
            @_out << "<#{elem}\#{serialize_attrs(#{elem.inspect}, attrs)}>"
            if txt
              @_out << escape_html(txt)
            elsif block_given?
              instance_eval(&block)
            end
            @_out << "</#{elem}>"
            self
          end
        TAGDEF
      end
    end
  end

  class SaneHtml < FastHtml

    def serialize_attrs(elem, attrs)
      return '' if attrs.nil? || attrs.empty?
      allowed_keys = ElementAttributes[elem]
      unauthorized = (attrs.keys.map(&:to_sym) - allowed_keys).reject{|k| k=~/^data[_-]/}
      if unauthorized.any?
        raise BuildError, "#{unauthorized.join(', ')} not authorized in #{elem}"
      end
      ([nil] + attrs.sort.map do |xy|
        key, val = *xy
        key = key.to_s.gsub('_','-').to_sym
        val = val.to_s
        if BOOLEAN_ATTRIBUTES_HASH[key]
          key
        else
          v2 = escape_attr(val)
          val = "\"#{v2}\"" if v2 != val
          "#{key}=#{val}"
        end
      end).join(' ')
    end

    require 'builder/xchar'
    if ::String.method_defined?(:encode)
      def escape_html!(text)
        result = ::Builder::XChar.encode(text)
        begin
          result.encode(@encoding)
        rescue
          # if the encoding can't be supported, use numeric character references
          result.
            gsub(/[^\u0000-\u007F]/) {|c| "&##{c.ord};"}.
            force_encoding('ascii')
        end
      end
    else
      def escape_html!(text)
        text.to_xs((@encoding != 'utf-8' or $KCODE != 'UTF8'))
      end
    end

    # symbol === safe
    def escape_html(text)
      return if text.kind_of? Symbol
      escape_html!(text.to_s)
    end

    # symbol === safe
    def escape_attr(text)
      escape_html!(text).gsub('"', '&quot;')
    end

    # TODO: nice indent
    def to_s
      map_join = lambda do |level|
        return lambda do |obj|
          if obj.kind_of? Array
            line = obj.join
            if line.size < 78
              line
            else
              obj.map(&map_join[level + 1]).join("\n")
            end
          else
            ("  " * level) + obj.to_s
          end
        end
      end
      yo = map_join[-1]
      yo[@_out]
    end

    SANE_TAGS.each do |elem|
      if SELF_CLOSING_TAGS.include? elem
        eval <<-TAGDEF, binding, __FILE__, __LINE__+1
          def #{elem}(attrs = {}, &block)
            railse BuildError, "#{elem} is a self-closing tag" if block_given?
            @_current << "<#{elem}\#{serialize_attrs(#{elem.inspect}, attrs)}>"
            self
          end
        TAGDEF
      else
        eval <<-TAGDEF, binding, __FILE__, __LINE__+1
          def #{elem}(txt = nil, attrs  = nil, &block)
            if attrs.nil? && txt.kind_of?(::Hash)
              txt, attrs = nil, txt
            end
            #raise BuildError, "need either text or block" unless txt || block_given?
            out = @_current
            out << "<#{elem}\#{serialize_attrs(#{elem.inspect}, attrs)}>"
            if txt
              out << escape_html(txt)
            elsif block_given?
              new_curr = []
              @_current << new_curr
              @_current = new_curr
              instance_eval(&block)
            end
            out << "</#{elem}>"
            self
          end
        TAGDEF
      end
    end

  end
end
