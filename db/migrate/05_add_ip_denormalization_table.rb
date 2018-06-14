class AddIpDenormalizationTable < ActiveRecord::Migration[5.2]
  def change
    create_table :denormalization_ips do |t|
      t.text :ip, null: false
      t.text :logins, array: true, default: []
      t.integer :logins_quantity, default: 0
    end

    add_index :denormalization_ips, :ip, unique: true
    add_index :denormalization_ips, :logins_quantity

    ActiveRecord::Base.connection.execute(
      "CREATE OR REPLACE FUNCTION array_undup(ANYARRAY)
      RETURNS ANYARRAY
      LANGUAGE SQL
      AS $$
      SELECT ARRAY(
        SELECT DISTINCT $1[i]
        FROM generate_series(
          array_lower($1,1),
          array_upper($1,1)
        ) AS i
      );
      $$;"
    )
  end
end
