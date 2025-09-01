class UpdateSubmissions < ActiveRecord::Migration[7.0]
  def change
    # Section 1: Links
    add_column :submissions, :code_url, :string
    add_column :submissions, :demo_url, :string

    # Section 2: Identity
    add_column :submissions, :email, :string
    add_column :submissions, :slack_id, :string

    # Section 3: Ship Info
    add_column :submissions, :ship_name, :string
    add_column :submissions, :is_hardware, :boolean, default: false
    add_column :submissions, :video_upload, :string

    # Section 4: Extra Info
    add_column :submissions, :birthday, :date
    add_column :submissions, :street, :string
    add_column :submissions, :address_line2, :string
    add_column :submissions, :city, :string
    add_column :submissions, :state, :string
    add_column :submissions, :zip, :string
    add_column :submissions, :country, :string
    add_column :submissions, :shipping_name, :string
    add_column :submissions, :github_username, :string
    add_column :submissions, :hackatime_project, :string
    add_column :submissions, :hours_collected, :integer, default: 0

    # Section 5: Prize + Gallery
    add_column :submissions, :desired_prize, :string
    add_column :submissions, :in_gallery, :boolean, default: false

    # Useful indexes
    add_index :submissions, :email
    add_index :submissions, :slack_id, unique: true
  end
end
