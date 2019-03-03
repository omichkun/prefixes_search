namespace 'prefix' do
  desc "loads prefixes into base from prefixes.csv placed in app/lib/"
  task(:import => :environment) do
    require 'csv'
    file = "#{Rails.root}/lib/prefixes.csv"
    csv = CSV.read(file,{ :col_sep => ',' })
    csv.each do |row|
      Prefix.create value: row[0], min_length: row[2].to_i, max_length: row[1].to_i, usage: row[3], comment: remove_umlauts(row[4])
    end
  end

end

def remove_umlauts(string)
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
