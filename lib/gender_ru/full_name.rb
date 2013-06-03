# encoding: utf-8

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