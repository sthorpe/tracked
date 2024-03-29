class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string      :name
      t.string      :url
      t.integer     :count
    end
  end

  def self.down
    drop_table :sites
  end
end
