module SugoiAliasesUpdator
  class AliasesParser

    attr_accessor :changed_labels

    def initialize(filepath)
      @native_lines = File.readlines(filepath)
      @changed_labels = []
    end

    def add(target_email, to)
      check_labels!(to)
      to.each do |x|
        unless label_mails_hash[x].include?(target_email)
          label_mails_hash[x].push(target_email)
          @changed_labels << x
        end
      end
      render!
    end

    def rm(target_email, from)
      if ['ALL'] == from
        label_mails_hash.each do |label, emails|
          if emails.include?(target_email)
            label_mails_hash[label].delete(target_email)
            @changed_labels << label
          end
        end
        return render!
      end

      check_labels!(from)
      from.each do |label|
        if label_mails_hash[label].include?(target_email)
          label_mails_hash[label].delete(target_email)
          @changed_labels << label
        end
      end
      render!
    end

    def list(target_email)
      finded = []
      label_mails_hash.each do |key, value|
        finded.push(key) if value.include?(target_email)
      end
      finded.join(',')
    end

    def render!
      new_lines = []
      @native_lines.each do |line|
        line_paser = LineParser.new(line)
        if line_paser.is_aliaes_line && @changed_labels.include?(line_paser.label)
          line = "#{line_paser.label}:#{line_paser.margin}#{label_mails_hash[line_paser.label].join(", ")}\n"
        end
        new_lines << line
      end
      new_lines.join
    end

    private

    def label_mails_hash
      @label_mails_hash ||= {}.tap do |h|
        @native_lines.each do |line|
          line_paser = LineParser.new(line)
          if line_paser.is_aliaes_line
            emails_line = line_paser.emails_line
            h[line_paser.label] = line_paser.emails_line.split(/\,\s?/)
          end
        end
      end
    end

    def check_labels!(inputed_labels)
      unknown_labels = inputed_labels - label_mails_hash.keys
      if unknown_labels.size > 0
        raise("unknown labels #{unknown_labels.join(', ')}")
      end
    end
  end
end
