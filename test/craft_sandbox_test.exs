defmodule CraftSandboxTest do
  use ExUnit.Case

  setup do
    :ok = Craft.Sandbox.join("sandbox-#{inspect(self())}")
    :ok
  end

  describe "error tuple shape" do
    test "command/3 returns 3-tuple error when group is unknown" do
      assert {:error, :unknown_group, %{}} =
               Craft.Sandbox.command(:anything, :nonexistent_group, [])
    end

    test "async_command/3 returns 3-tuple error when group is unknown" do
      assert {:error, :unknown_group, %{}} =
               Craft.Sandbox.async_command(:anything, :nonexistent_group, [])
    end
  end

  describe "stop_member/1" do
    test "stops a running member" do
      name = :"stop_member_test_group_#{System.unique_integer([:positive])}"

      :ok = Craft.Sandbox.start_group(name, [node()], Craft.SimpleMachine, [])

      assert :ok = Craft.Sandbox.stop_member(name)

      assert {:error, :unknown_group, %{}} = Craft.Sandbox.command({:put, :k, :v}, name, [])
    end
  end

  describe "stop_group/1" do
    test "stops the group's (sole) member" do
      name = :"stop_group_test_group_#{System.unique_integer([:positive])}"

      :ok = Craft.Sandbox.start_group(name, [node()], Craft.SimpleMachine, [])

      assert :ok = Craft.Sandbox.stop_group(name)

      assert {:error, :unknown_group, %{}} = Craft.Sandbox.command({:put, :k, :v}, name, [])
    end
  end
end
