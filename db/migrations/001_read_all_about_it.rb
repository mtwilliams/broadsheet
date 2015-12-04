Sequel.migration do
  change do
    create_table :users do
      primary_key :id

      column :role, :text, :default => 'user'

      column :portrait, :text, :default => '/images/transparent.gif'
      column :name, :text
      column :email, :text, :unique => true
      column :bio, :text

      column :karma, :integer, :default => 0

      column :joined_at, :timestamp
      column :verified_their_email_at, :timestamp
      column :subscribed_to_newsletter_at, :timestamp
    end

    create_table :sessions do
      primary_key :id

      foreign_key :owner_id, :users, :on_delete => :cascade

      column :started_at, :timestamp
      column :expires_at, :timestamp
      column :invalidated_at, :timestamp
    end

    create_table :tokens do
      primary_key :id

      foreign_key :owner_id, :users, :on_delete => :cascade

      column :type, :text
      column :unguessable, :text

      column :expires_at, :timestamp
      column :reedemed_at, :timestamp
      column :invalidated_at, :timestamp
    end

    create_table :posts do
      primary_key :id

      foreign_key :poster_id, :users, :on_delete => :cascade

      column :title, :text
      column :link, :text
      column :text, :text

      column :votes, :integer, :default => 0

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end

    create_table :comments do
      primary_key :id

      foreign_key :owner_id, :users, :on_delete => :cascade

      foreign_key :post_id, :post, :on_delete => :cascade
      foreign_key :parent_id, :comments, :on_delete => :cascade

      column :markdown, :text

      column :votes, :integer, :default => 0

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end

    create_table :votes_on_posts do
      primary_key :id

      foreign_key :post_id, :posts, :on_delete => :cascade
      foreign_key :voter_id, :users, :on_delete => :cascade
    end

    create_table :votes_on_comments do
      primary_key :id

      foreign_key :comment_id, :comments, :on_delete => :cascade
      foreign_key :voter_id, :users, :on_delete => :cascade
    end
  end
end
