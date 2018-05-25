# frozen_string_literal: true

module ProductMigration
  def up
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.boolean :available
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end

if Dummy::RAILS_VERSION == 5.2
  class CreateProducts < ActiveRecord::Migration[Dummy::RAILS_VERSION]
    extend ProductMigration
  end
else
  class CreateProducts < ActiveRecord::Migration
    extend ProductMigration
  end
end
