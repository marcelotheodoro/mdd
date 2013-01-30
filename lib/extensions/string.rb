# -*- encoding : utf-8 -*-
require 'active_support/core_ext'

class String
  
  # Remove as letras acentuadas
  #
  # Exemplo:
  #  String.remover_acentos('texto está com acentuação') ==> 'texto esta com acentuacao'
  def self.remover_acentos(texto)
    return texto if texto.blank?
    texto = texto.gsub(/(á|à|ã|â|ä)/, 'a').gsub(/(é|è|ê|ë)/, 'e').gsub(/(í|ì|î|ï)/, 'i').gsub(/(ó|ò|õ|ô|ö)/, 'o').gsub(/(ú|ù|û|ü)/, 'u')
    texto = texto.gsub(/(Á|À|Ã|Â|Ä)/, 'A').gsub(/(É|È|Ê|Ë)/, 'E').gsub(/(Í|Ì|Î|Ï)/, 'I').gsub(/(Ó|Ò|Õ|Ô|Ö)/, 'O').gsub(/(Ú|Ù|Û|Ü)/, 'U')
    texto = texto.gsub(/ñ/, 'n').gsub(/Ñ/, 'N')
    texto = texto.gsub(/ç/, 'c').gsub(/Ç/, 'C')
    texto
  end

  # Remove as letras acentuadas
  #
  # Exemplo:
  #  'texto está com acentuação'.remover_acentos ==> 'texto esta com acentuacao'
  def remover_acentos
    String.remover_acentos(self)
  end
  
  def to_alias
    self.remover_acentos.gsub(/ /, '_').underscore.to_sym
  end
  
end
