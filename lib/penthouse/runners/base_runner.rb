#
# This class provides an abstract for the runner interface. Whilst any Proc
# could be used, it's easiest to sub-class then overwrite the #load_tenant
# method.
#
# A runner class's responsibility in Penthouse is to receive an identifier for
# a tenant and a block, and to execute that block within the tenant
#

module Penthouse
  module Runners
    class BaseRunner

      # @param tenant_identifier [String, Symbol] The identifier for the tenant
      # @param block [Block] The code to execute within the tenant
      # @raise [Penthouse::TenantNotFound] if the tenant cannot be switched to
      def self.call(tenant_identifier, &block)
        load_tenant(tenant_identifier).call do |tenant|
          Penthouse.with_tenant(tenant.identifier) do
            block.yield(tenant)
          end
        end
      end

      # @param tenant_identifier [String, Symbol] The identifier for the tenant
      # @return [Penthouse::Tenants::BaseTenant] An instance of a tenant
      # @raise [Penthouse::TenantNotFound] if the tenant cannot be switched to
      def self.load_tenant(tenant_identifier)
        raise NotImplementedError
      end
    end
  end
end
