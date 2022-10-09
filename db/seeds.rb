# frozen_string_literal: true

DB[:ads].insert(
  title: 'ad 1',
  description: 'description 1',
  city: 'Moscow',
  user_id: 1,
  created_at: Time.now,
  updated_at: Time.now
)
DB[:ads].insert(
  title: 'ad 2',
  description: 'description 2',
  city: 'Sochi',
  user_id: 1,
  created_at: Time.now,
  updated_at: Time.now
)
