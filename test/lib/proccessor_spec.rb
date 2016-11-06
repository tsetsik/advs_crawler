require 'test_helper'

require_all 'lib'

class TestProccessor < Minitest::Test
  context 'test proccessor for runing the adapters' do
    setup do
      @diff_watcher = MiniTest::Mock.new
      @proccessor = Proccessor.new(@diff_watcher)
    end

    should 'add adapter to que by #add_adapter' do
      adapter = MiniTest::Mock.new

      result = @proccessor.add_adapter(adapter)
      assert_equal(result.length, 1)
      assert_equal(result, [adapter])
    end

    should 'run the adapters and notify observers by #run' do
      adapter = MiniTest::Mock.new
      adv = { id: 1, link: 'some link' }

      adapter.expect(:proccess, [adv])
      @proccessor.add_adapter(adapter)

      diff_watch_result = [{ adapter.class.name => [adv] }]
      @diff_watcher.expect(:call, [adv], diff_watch_result)

      @proccessor.run
    end

    # should 'return hash by #find_adv' do
    #   id = 15
    #   row = { id: 1, name: 'Test advs' }
    #   @sql_obj.expect(:results_as_hash=, true, [true])
    #   @sql_obj.expect(:execute, [row], [String, [@adapter, id]])

    #   assert_equal(@db.find_adv(@adapter, id), row)
    # end
  end
end
