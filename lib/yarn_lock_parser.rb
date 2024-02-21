# frozen_string_literal: true

require "yarn_lock_parser/version"
require "set"

module YarnLockParser
  class Parser
    LOCKFILE_VERSION = 1

    TOKEN_TYPES = {
      boolean: "BOOLEAN",
      string: "STRING",
      identifier: "IDENTIFIER",
      eof: "EOF",
      colon: "COLON",
      newline: "NEWLINE",
      comment: "COMMENT",
      indent: "INDENT",
      invalid: "INVALID",
      number: "NUMBER",
      comma: "COMMA",
    }.freeze

    Token = Struct.new(:type, :value)

    class << self
      attr_accessor :tokens, :token

      def parse(file_path)
        yarn_file = File.read(file_path)

        return nil unless compatible?(yarn_file)

        tokenise(yarn_file)
        res = parse_tokenized_items
        convert_objects(res)
      end

      private

      def tokenise(input)
        @tokens = []
        last_new_line = false

        build_token = proc { |type, value| Token.new(type, value) }
        until input.empty?
          chop = 0
          if input[0] == "\n" || input[0] == "\r"
            chop += 1
            chop += 1 if input[1] == "\n"

            tokens << build_token.call(TOKEN_TYPES[:newline])
          elsif input[0] == "#"
            chop += 1
            next_new_line = input.index("\n", chop)
            next_new_line = input.length if next_new_line == -1
            val = input[chop..next_new_line]
            chop = next_new_line
            tokens << build_token.call(TOKEN_TYPES[:comment], val)
          elsif input[0] == " "
            if last_new_line
              indent_size = count_indent_size(input)
              tokens << build_token.call(TOKEN_TYPES[:indent], indent_size / 2)
            else
              chop += 1
            end
          elsif input[0] == '"'
            chop, val = extract_value(input)
            tokens << build_token.call(TOKEN_TYPES[:string], val.gsub(/\"|:/, ""))
          elsif /^[0-9]/.match?(input)
            val = /^[0-9]+/.match(input).to_s
            chop = val.length
            tokens << build_token.call(TOKEN_TYPES[:number], val.to_i)
          elsif /^true/.match?(input)
            tokens << build_token.call(TOKEN_TYPES[:boolean], true)
            chop = 4
          elsif /^false/.match?(input)
            tokens << build_token.call(TOKEN_TYPES[:boolean], false)
            chop = 5
          elsif input[0] == ":"
            chop += 1
            tokens << build_token.call(TOKEN_TYPES[:colon])
          elsif input[0] == ","
            chop += 1
            tokens << build_token.call(TOKEN_TYPES[:comma])
          elsif input.scan(%r{^[a-zA-Z/.-]}).size.positive?
            chop = count_special_characters(input)
            name = input[0..chop - 1]
            tokens << build_token.call(TOKEN_TYPES[:string], name)
          else
            tokens << build_token.call(TOKEN_TYPES[:invalid])
            next
          end

          if chop.nil?
            tokens << build_token.call(TOKEN_TYPES[:invalid])
            next
          end
          last_new_line = input[0] == "\n" || (input[0] == "\r" && input[1] == "\n")
          input = input[chop..-1]
        end
        tokens << build_token.call(TOKEN_TYPES[:eof])

        self.tokens = tokens.to_enum
        self.token = tokens.peek
      end

      def parse_tokenized_items(indent = 0)
        obj = {}
        loop do
          prop_token = token
          if prop_token.type == TOKEN_TYPES[:newline]
            next_token = tokens.next
            self.token = next_token
            if indent.zero?
              next
            end # if we have 0 indentation then the next token doesn't matter

            if next_token.type != TOKEN_TYPES[:indent]
              break
            end # if we have no indentation after a newline then we've gone down a level

            break if next_token.value != indent

            self.token = tokens.next
          elsif prop_token.type == TOKEN_TYPES[:indent]
            break if prop_token.value != indent

            self.token = tokens.next
          elsif prop_token.type == TOKEN_TYPES[:eof]
            break
          elsif prop_token.type == TOKEN_TYPES[:string]
            key = prop_token.value

            raise StandartError, "Expected a key" if key.nil?

            keys = [key]
            self.token = tokens.next

            #  support multiple keys
            while token.type == TOKEN_TYPES[:comma]
              self.token = tokens.next

              raise StandardError, "Expected string" if token.type != TOKEN_TYPES[:string]

              keys << token.value
              self.token = tokens.next
            end

            was_colon = token.type == TOKEN_TYPES[:colon]

            self.token = tokens.next if was_colon

            if valid_prop_value_token?(token)
              keys.each do |k|
                obj[k] = token.value
              end

              self.token = tokens.next
            elsif was_colon
              # parse object
              val = parse_tokenized_items(indent + 1)

              keys.each do |k|
                obj[k] = val
              end

              break if indent.positive? && token.type != TOKEN_TYPES[:indent]
            else
              raise StandardError, "Invalid value type"
            end
          elsif prop_token.type == TOKEN_TYPES[:comment]
            self.token = tokens.next
            next
          else
            raise StandardError, "Unkown token #{token}"
          end
        end

        obj
      end

      def count_special_characters(input)
        i = 0
        i += 1 until [":", "\n", "\r", ",", " "].include?(input[i]) || input[i].nil?

        i
      end

      def count_indent_size(input)
        indent_size = 1
        indent_size += 1 while input[indent_size] == " "

        raise StandardError, "Invalid number of spaces" if indent_size.odd?

        indent_size
      end

      def extract_value(input)
        between_quotes = /\"(.*?)\"/
        val = input.match(between_quotes).to_s

        [val.size, val]
      end

      def compatible?(yarn_file)
        version_regex = /yarn lockfile v(#{LOCKFILE_VERSION})$/.freeze

        lines = yarn_file.split("\n", 2) # get first two lines

        lines.each do |line|
          return true if line.match?(version_regex)
        end

        false
      end

      def convert_objects(dependencies)
        deps = Set.new
        dependencies.each do |dependency, details|
          name = dependency.match(/(^.*)(@)(.*)/i).captures.first
          version = details["version"]
          deps.add({ name: name, version: version })
        end

        deps.to_a
      end

      # boolean
      def valid_prop_value_token?(token)
        [TOKEN_TYPES[:boolean], TOKEN_TYPES[:string], TOKEN_TYPES[:number]].include?(token.type)
      end
    end
  end
end
