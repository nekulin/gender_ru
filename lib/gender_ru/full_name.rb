# encoding: utf-8
require 'yaml'

module GenderRu
  class FullName

    attr_reader :name, :surname, :patronymic, :gender, :ethnicity

    SOGL_LETTERS = 'бвгджзйклмнпрстуфхцчшщ'

    def initialize(options = {})
      @name       = options[:name].to_s
      @surname    = options[:surname].to_s
      @patronymic = options[:patronymic].to_s.gsub(/ичь$/, 'ич')
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

    def russian?
      ethnicity == :russian
    end

    def azerbaijanian?
      ethnicity == :azerbaijanian
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

    private

    def analyze
      unless @patronymic.blank?
        # It detects gender and ethnicity by patronymic.
        if @patronymic =~ /ич$/
          russian!
          male!
        elsif @patronymic =~ /на$/
          russian!
          female!
        elsif @patronymic =~ /лы$/
          azerbaijanian!
          male!
        elsif @patronymic =~ /зы$/
          azerbaijanian!
          female!
        end
      end
    end

    def male!
      @gender = :male
    end

    def female!
      @gender = :female
    end

    def russian!
      @ethnicity = :russian
    end

    def azerbaijanian!
      @ethnicity = :azerbaijanian
    end

  end
end