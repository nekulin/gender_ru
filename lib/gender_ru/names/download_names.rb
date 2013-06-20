# encoding: utf-8
# Этот скрипт идет только для ознакомления и предназначен для скачивания имен из
# http://www.molomo.ru/inquiry/

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

BASE_URL = 'http://www.molomo.ru/inquiry/%s_%s.html'

SOURCES = %w(azerbaijani albanian arabian armenian african bulgarian hungarian vietnamese greek georgian danish hebrew egyptian hindi irish icelandic spanish italian kazakh chinese korean lithuanian mongolian norwegian dutch german polish russian romani serbian slovenian thai tatar finnish french croatian gypsy czehoslovakian chechen swedish swiss scottish yakut japanese)

SOURCES.each do |source|
  filename = source + '.yml'
  data = {}
  [:male, :female].each do |gender|
    doc = Nokogiri::HTML(open(BASE_URL % [source, gender]))
    data[gender] = doc.css('.content p span').reduce([]){ |arr, n| arr += n.text.gsub(/\([^\)]*\)/, '').strip.split(',').map(&:strip) and arr }
  end

  File.open(filename, 'w+') do |f|
    f.write data.to_yaml
  end
end
