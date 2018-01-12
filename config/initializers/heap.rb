# frozen_string_literal: true

Heap.app_id = Rails.env.test? ? 'no_id' : ENV['HEAP_ANALYTICS_ID']
