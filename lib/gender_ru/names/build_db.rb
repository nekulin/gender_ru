# encoding: utf-8
#
# Скрипт строит общую базу имен с вероятностью
#
require 'yaml'

EMAP = {
  'azerbaijani' => :azerbaijanian,
  'arabian' => :arab,
  'croatian' => :croat,
  'czehoslovakian' => :czech,
  'danish' => :dane,
  'finnish' => :finn,
  'hindi' => :hindu,
  'mongolian' => :mongol,
  'polish' => :pole,
  'scotish' => :scot,
  'serbian' => :serb,
  'slovenian' => :slovene,
  'spanish' => :spaniard,
  'swedish' => :swede
}

SOURCES = %w(azerbaijani albanian arabian armenian african belorussian bulgarian hungarian vietnamese greek georgian danish hebrew egyptian hindi irish icelandic spanish italian kazakh chinese korean lithuanian mongolian norwegian dutch german polish russian romani serbian slovenian thai tatar finnish french croatian gypsy czehoslovakian chechen swedish swiss scottish yakut japanese ukranian)

freq_map = {}
SOURCES.each do |source|
  data = {}
  File.open(source + '.yml', 'r') do |f|
    data = YAML.load(f.read)
  end

  data.each do |k, names|
    names.each do |name|
      freq_map[name]||= 0
      freq_map[name] += 1
    end
  end
end

# Получаем вероятность, что имя пренадлежит нации

p_map = {}
freq_map.each do |name, freq|
  p_map[name] = (1.0 - (freq.to_f - 1.0) / SOURCES.size.to_f).round(2)
end

freq_map.clear

# Строим Базу
base = {}
SOURCES.each do |source|
  data = {}
  File.open(source + '.yml', 'r') do |f|
    data = YAML.load(f.read)
  end

  eth = EMAP[source].nil? ? source.to_sym : EMAP[source]

  data.each do |gender, names|
    names.each do |name|
      base[eth] ||= {male: {}, female: {}}
      base[eth][gender][name] = p_map[name]
    end
  end
end

File.open('base.yml', 'w+') do |f|
  f.write(base.to_yaml)
end
