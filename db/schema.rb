# Version: 20221009091622
Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id
      column :title, "text", :null=>false
      column :description, "text", :null=>false
      column :city, "text", :null=>false
      column :lat, "double precision"
      column :lon, "double precision"
      column :user_id, "bigint", :null=>false
      column :created_at, "timestamp with time zone", :null=>false
      column :updated_at, "timestamp with time zone", :null=>false
      
      index [:user_id]
    end
    
    create_table(:reference_books) do
      primary_key :id, :type=>:Bignum
      column :volume, "character varying", :null=>false
      column :description, "jsonb"
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
      
      index [:description]
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
  end
end
