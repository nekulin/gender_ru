# encoding: utf-8
require 'yaml'

module GenderRu
  class FullName

    attr_reader :name, :surname, :patronymic, :gender, :ethnicity, :ethnicity_data

    SOGL_LETTERS = 'бвгджзйклмнпрстуфхцчшщ'

    BASE_OF_NAMES = File.join(Pathname.new(__FILE__).dirname, 'names','base.yml')

    GEORGIAN_FACTOR = {
        'дзе'   => 1.0,
        'швили' => 1.0,
        'ури'   => 1.0,
        'ули'   => 1.0,
        'иа'    => 0.98,
        'ия'    => 0.98,
        'иани'  => 1.0,
        'уа'    => 0.98,
        'ава'   => 1.0,
        'ши'    => 1.0
    }.freeze

    AZERBAIJANIAN_FACTOR = {
        'ли'   => 1.0,
        'заде' => 1.0,
        'оглу' => 1.0
    }.freeze

    ARMENIAN_FACTOR = {
        'ян'   => 1.0,
        'янц'  => 1.0,
        'уни'  => 1.0
    }.freeze

    BULGARIAN_FACTOR = {
        'ов' => 0.6
    }.freeze

    GREEK_FACTOR = {
        'пулос' => 1.0,
        'кос'   => 1.0,
        'иди'   => 1.0
    }.freeze

    ITALIAN_FACTOR = {
        'ини' => 1.0,
        'они' => 1.0,
        'оли' => 1.0,
        'ери' => 1.0,
        'лли' => 1.0,
        'тти' => 1.0,
        'ччи' => 1.0,
        'ццы' => 1.0
    }.freeze

    LITHUANIAN_FACTOR = {
        'ус'    => 1.0,
        'ис'    => 1.0,
        'ас'    => 1.0,
        'ене'   => 1.0,
        'уте'   => 1.0,
        'ите'   => 1.0,
        'айте'  => 1.0
    }.freeze

    LATVIAN_FACTOR = {
        'ньш' => 1.0,
        'иня' => 1.0
    }

    ROMANI_FACTOR = {
        'ску'   => 1.0,
        'у'     => 0.8,
        'ул'    => 1.0,
        'ан'    => 1.0
    }.freeze

    SERB_FACTOR = {
        'ич' => 0.8
    }.freeze

    # http://www.vsem.name/20-familnyy-suffiks-i-istoriya-proishozhdeniya-familii.html
    RUSSIAN_FACTOR = {
        'ев' => 1.0,
        'ёв' => 1.0,
        'ов' => 0.6,
        'ева' => 1.0,
        'ёва' => 1.0,
        'ова' => 0.6,
        'овец' => 1.0,
        'евец' => 1.0,
        'инец' => 1.0,
        'ин'   => 1.0,
        'инов' => 0.8,
        'иков' => 0.8,
        'цев'  => 1.0,
        'шин'  => 1.0,
        'кшин' => 1.0,
        'ишин' => 1.0,
        'ихин' => 1.0,
        'щин'  => 1.0,
        'щев'  => 1.0,
        'ыкин' => 1.0,
        'ыгин' => 1.0,
        'итин' => 1.0,
        'итинов' => 1.0,
        'аков' => 1.0,
        'уков' => 0.8,
        'яков' => 0.8,

        'ина'   => 1.0,
        'инова' => 0.8,
        'икова' => 0.8,
        'цева'  => 1.0,
        'шина'  => 1.0,
        'кшина' => 1.0,
        'ишина' => 1.0,
        'ихина' => 1.0,
        'щина'  => 1.0,
        'щева'  => 1.0,
        'ыкина' => 1.0,
        'ыгина' => 1.0,
        'итина' => 1.0,
        'итинова' => 1.0,
        'акова' => 1.0,
        'укова' => 0.8,
        'якова' => 0.8,

        'ка'   => 0.5,
        'ха'   => 0.5,
        'енков'=> 0.9,
        'ёнков'=> 0.9,
        'ков'  => 0.8,
        'чев'  => 1.0,
        'чов'  => 0.8,
        'вский'=> 1.0,
        'нский'=> 1.0,
        'ский' => 0.8,
        'ской' => 0.8,
        'цкий' => 0.8,
        'цкой' => 0.8,
        'инский' => 1.0,
        'иньский' => 1.0,

        'енкова'=> 0.9,
        'ёнкова'=> 0.9,
        'кова'  => 0.8,
        'чева'  => 1.0,
        'чова'  => 0.8,
        'вская'=> 1.0,
        'нская'=> 1.0,
        'ская' => 0.8,
        'цкая' => 0.8,
        'инская' => 1.0,
        'иньская' => 1.0,

        'их' => 1.0,
        'ых' => 1.0,
        'катов' => 0.8,
        'манов' => 0.8,
        'ров' => 0.8,
        'рев' => 1.0,
        'рёв' => 1.0,
        'аев' => 1.0,
        'иев' => 1.0,
        'еев' => 1.0,
        'яев' => 1.0,
        'оев' => 1.0,

        'катова' => 0.8,
        'манова' => 0.8,
        'рова' => 0.8,
        'рева' => 1.0,
        'рёва' => 1.0,
        'аева' => 1.0,
        'иева' => 1.0,
        'еева' => 1.0,
        'яева' => 1.0,
        'оева' => 1.0,
    }.freeze

    UKRANIAN_FACTOR = {
        'ак'  => 0.8,
        'ук'  => 0.8,
        'юк'  => 0.8,
        'чак' => 0.8,
        'чук' => 0.8,
        'ко'  => 1.0,
        'хо'  => 1.0,
        'ка'   => 0.8,
        'ха'   => 0.8,
        'енко' => 1.0,
        'енько'=> 1.0,
        'ченко'=> 1.0,
        'щенко'=> 1.0,
        'ич'   => 0.8,
        'ыч'   => 1.0,
        'ский' => 0.8,
        'ской' => 0.8,
        'цкий' => 0.8,
        'цкой' => 0.8,
        'ская' => 0.8,
        'цкая' => 0.8,
        'кат'  => 1.0,
        'ёц'   => 0.8,
        'ман'  => 0.8,
        'арь'  => 1.0,
        'ас'   => 1.0,
        'ась'  => 1.0,
        'ай'   => 1.0,
        'ей'   => 1.0,
        'яй'   => 1.0,
        'ейк'  => 1.0,
        'очко' => 1.0,
        'ик'   => 1.0,
        'ник'  => 1.0,
        'ив'   => 1.0,
        'ец'   => 1.0,
        'айло' => 1.0,
        'ба'   => 1.0,
        'да'   => 1.0,
        'ра'   => 1.0,
        'ан'   => 1.0,
        'но'   => 1.0,
        'ый'   => 1.0
    }.freeze

    BELORUSSIAN_FACTOR = {
        'ович' => 1.0,
        'евич' => 1.0,
        'ак'  => 0.8,
        'ук'  => 0.8,
        'юк'  => 0.8,
        'чак' => 0.8,
        'чук' => 0.8,
        'енко' => 0.8,
        'енько'=> 0.8,
        'еня'  => 1.0,
        'ёня'  => 1.0,
        'ар'   => 1.0
    }.freeze

    def initialize(options = {})
      attrs       = options.symbolize_keys.slice(:name, :patronymic, :surname)
      @name       = normalize_name attrs[:name]
      @surname    = normalize_name attrs[:surname].to_s
      @patronymic = normalize_name attrs[:patronymic].to_s.gsub(/ичь$/, 'ич')
      @gender     = :unknown
      @ethnicity  = :unknown

      analyze
    end

    def male_surname
      if female?
        parts = @surname.split('-').map do |part|
          if m = part.match(/([^#{SOGL_LETTERS}]?[#{SOGL_LETTERS}]+)(яя|ая|а)$/)
            part = case m[2]
                     when 'яя'
                       part.gsub(/яя$/, 'ий')
                     when 'ая'
                       unless m[1] =~ /[ф]{1}$/
                         part.gsub(/ая$/, m[1] =~ /[кфхцчшщ]{1}$/ ? 'ий' : 'ой')
                       else
                         part
                       end
                     when 'а'
                       if ['ов', 'ев', 'ин', 'ёв'].include?(m[1])
                         part.mb_chars[0, part.size - 1]
                       else
                         part
                       end
                     else
                       part
                   end
          end
          part
        end

        parts.join('-')
      else
        @surname
      end
    end

    def male?
      gender == :male
    end

    def female?
      gender == :female
    end

    def humanize(method, locale = :en)
      value = send(method)
      locale_data = self.class.locale_data[locale.to_s]
      if locale_data.is_a?(Hash) && locale_data[method.to_s].is_a?(Hash) && locale_data[method.to_s][value.to_s].present?
        locale_data[method.to_s][value.to_s]
      else
        value.to_s
      end
    end

    def self.locale_data
      unless defined? @@locale_data
        @@locale_data = {}
        Dir.glob(File.join(Pathname.new(__FILE__).dirname, 'locale','*.yml')).each do |filename|
          yaml = YAML.load_file(filename)
          @@locale_data.merge!(yaml)
        end
        @@locale_data.freeze
      end
      @@locale_data
    end

    def self.ethnicity options
      name = new options
      name.ethnicity
    end

    def self.gender options
      name = new options
      name.gender
    end

    def self.base_of_names
      @@base_of_names ||= YAML.load(open(BASE_OF_NAMES))
    end

    private

    def normalize_name(raw_name)
      name = raw_name.to_s
      names = name.split('-').reduce([]) do |nms, subname|
        nms << subname.mb_chars.downcase.capitalize.to_s
      end
      names.join('-')
    end

    def analyze
      @ethnicity_data = {}
      @gender_data = { male: 0.0, female: 0.0 }

      analyze_surname
      analyze_name
      analyze_patronymic

      finalize_ethnicity
      finalize_gender
    end

    def analyze_surname
      return if @surname.blank?

      [:azerbaijanian, :armenian, :georgian, :belorussian, :bulgarian, :greek, :italian,
       :lithuanian, :latvian, :romani, :russian, :serb, :ukranian].each do |ethnicity|
        check_ethnicity_factor ethnicity
      end
    end

    def analyze_name
      return if @name.blank?

      self.class.base_of_names.each do |ethnicity, names|
        if names[:male][@name]
          add_factor ethnicity, names[:male][@name]
          @gender_data[:male] += 1.0
        end

        if names[:female][@name]
          add_factor ethnicity, names[:female][@name]
          @gender_data[:female] += 1.0
        end
      end
    end

    def analyze_patronymic
      return if @patronymic.blank?

      name = nil

      if @patronymic =~ /^(.*)(евич|ович|евна|овна)$/
        case $2
          when 'евич', 'евна'
            if $1[-1] == 'ь'
              len = $1.size
              name = $1[0, len - 1] + 'ий'
            elsif %w(а я и о е).include?($1[-1])
              name = $1 + 'й'
            else
              name = $1 + 'ь'
            end
          when 'ович', 'овна'
            name = $1
        end

        if $2[-1] == 'а'
          @gender_data[:female] += 1.0
        else
          @gender_data[:male] += 1.0
        end

      elsif @patronymic =~ /^(.*)(ич|инична)$/
        if $1[-1] = 'ь'
          name = $1 + 'я'
        else
          name = $1 + 'а'
        end
      end

      self.class.base_of_names.each { |ethnicity, names|
        add_factor(ethnicity, names[:male][name]) if names[:male][name]
      } unless name.blank?
    end

    def finalize_ethnicity
      max = @ethnicity_data.values.max
      best = @ethnicity_data.keys.select { |k| @ethnicity_data[k] == max }
      if best.size > 1 && best.include?(:russian)
        ethnicity! :russian
      else
        ethnicity! best.first
      end
    end

    def finalize_gender
      male!   if @gender_data[:male] > @gender_data[:female]
      female! if @gender_data[:male] < @gender_data[:female]
    end

    def check_ethnicity_factor(ethnicity)
      constant = ('GenderRu::FullName::%s_FACTOR' % ethnicity.to_s.upcase).constantize
      # Идея в том, чтобы суффиксы разбить на группы одинаковой длины.
      # И поиск начинать от групп длинных суффиксов.
      groups = suffix_groups_from(constant.keys)
      groups.each do |group|
        add_factor(ethnicity, constant[$1]) and return if @surname =~ /(#{group.join('|')})$/
      end
    end

    def suffix_groups_from(suffixes)
      ary = suffixes.sort { |a, b| b.size <=> a.size }
      i, s, current, result = 0, 1000, [], []
      while i < ary.size
        suf = ary[i]

        if suf.size < s && current.size > 0
          result << current
          current = []
        end

        current << suf
        i += 1
        s = suf.size
      end
      result << current if current.size > 0
      result
    end

    def male!
      @gender = :male
    end

    def female!
      @gender = :female
    end

    def ethnicity!(value)
      return if value.blank?
      @ethnicity = value
    end

    def add_factor(ethnicity, factor)
      @ethnicity_data ||= {}
      @ethnicity_data[ethnicity]||= 0.0
      @ethnicity_data[ethnicity] += factor.round(2)
    end
  end
end
