Hanami::Model.migration do
  change do
    create_table :words do
      primary_key :id
      column :text, String
    end
  end
end
