#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require "sqlite3"
require "webrb/util"

module Webrb
  module Model
    DB = SQLite3::Database.new "test.db"

    class SQLite
      def initialize data = nil
        @hash = data
      end

      def [] name
        @hash[name.to_s]
      end
      def []= name, value
        @hash[name.to_s] = value
      end

      def save!
        unless @hash['id']
          self.class.create @hash
          return true
        end

        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end.join ","

        DB.execute <<EOF
update #{self.class.table} set #{fields} where id=#{@hash['id']};
EOF
        true
      end
      def save
        self.save! rescue false
      end

      def method_missing method
        if self.class.schema.include? method.to_s
          @hash[method.to_s]
        else
          super(method)
        end
      end

      def self.to_sql val
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def self.create values
        values.delete "id"
        keys = schema.keys - ["id"]
        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) : "null"
        end

        DB.execute <<EOF
INSERT INTO #{table} (#{keys.join ", "}) VALUES (#{vals.join ", "});
EOF

      data = Hash[keys.zip vals]
      data["id"] = DB.execute("SELECT last_insert_rowid();")[0][0]
      self.new data
      end
      def self.count
        DB.execute("SELECT count(*) FROM #{table}")[0][0]
      end

      def self.find id
        row = DB.execute <<EOF
select #{schema.keys.join ", "} from #{table} where id = #{id};
EOF
        data = Hash[schema.keys.zip row[0]]
        self.new data
      end

      def self.table
        Webrb.to_underscore name
      end
      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row['name']] = row['type']
        end
        @schema
      end
    end
  end
end
