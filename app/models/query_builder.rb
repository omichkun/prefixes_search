module QueryBuilder

  module Normalizer
    def self.normalize_string(search_string)
      subsearches = search_string.split(',')
      cleaned_subsearches = []
      subsearches.each do |subsearch|
        cleaned_subsearch = clean_unused_chars(subsearch)
        cleaned_subsearches << cleaned_subsearch if cleaned_subsearch.present?
      end
      cleaned_subsearches
    end

    def self.replace_umlauts(string)
      return nil if !string.present?
      umlauts  = {
          'ä' => 'ae',
          'Ä' => 'Ae',
          'Ö' => 'Oe',
          'ö' => 'oe',
          'Ü' => 'Ue',
          'ü' => 'ue',
          'ß' => 'ss'
      }
      umlauts.each do |umlaut, replace|
        string = string.gsub(/#{umlaut}/, replace)
      end
      string
    end

    def self.clean_unused_chars(subsearch)
      if subsearch.ascii_only?
        if is_number?(subsearch.gsub(/\W/, ''))
          subsearch.gsub(/\W/, '')
        else
          subsearch.split.join(' ')
        end
      else
        remove_umlauts(subsearch).split.join()
      end
    end

    def self.is_number?(string)
      true if Integer(string) rescue false
    end
  end



  module Builder
    def self.build(search_string)
      subsearches = Normalizer.normalize_string(search_string)
      make_array(subsearches)
    end


    def self.make_array(subsearches)
      descriptions = []
      subsearches.each do |subsearch|
        description = {}
        if is_number?(subsearch)
          subsearch.sub!(/^0/, '')
          prefixes = []
          2.upto(5) {|i| prefixes << subsearch[0, i]}
          description[:query] = "value IN (?)"
          description[:value] = prefixes
        else
          description[:query] = 'comment LIKE ?'
          description[:value] = "%#{subsearch}%"
        end
        descriptions << description
      end
      descriptions
    end

    def self.is_number?(string)
      true if Integer(string) rescue false
    end
  end


end