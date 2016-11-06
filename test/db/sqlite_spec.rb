require 'test_helper'
require 'active_support/core_ext/hash'

require_all 'db'

class TestSqlite < Minitest::Test
  context 'test sqlite wrapper' do
    setup do
      @adapter = 'test_adapter'
      @sql_obj = MiniTest::Mock.new
      @sql_obj.expect(:execute, nil, [String])
      @db = Sqlite.new(@sql_obj)
    end

    should 'return hash by #find_adv' do
      id = 15
      row = { id: 1, name: 'Test advs' }
      @sql_obj.expect(:results_as_hash=, true, [true])
      @sql_obj.expect(:execute, [row], [String, [@adapter, id]])

      assert_equal(@db.find_adv(@adapter, id), row)
    end

    should 'return nil if #find_adv can\'t find row' do
      id = 15
      @sql_obj.expect(:results_as_hash=, true, [true])
      @sql_obj.expect(:execute, [], [String, [@adapter, id]])
      assert_nil(@db.find_adv(@adapter, id))
    end

    should 'insert new row by #add_adv' do
      data = { name: 'Test adv', adapter: @adapter }
      insert = "INSERT INTO advs (#{data.keys.join(',')}) VALUES(:#{data.keys.join(', :')})"
      @sql_obj.expect(:execute, [], [insert, data])

      @db.add_adv(@adapter, data)
    end

    should 'update row by #update_adv' do
      data = { id: 1, price: '10000$' }
      update = 'UPDATE advs SET price = :price WHERE adapter = :adapter AND id = :id'
      @sql_obj.expect(:execute, [], [update, data.merge(adapter: @adapter)])

      @db.update_adv(@adapter, data)
    end
  end
end
