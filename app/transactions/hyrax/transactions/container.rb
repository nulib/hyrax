module Hyrax
  module Transactions
    class Container
      extend Dry::Container::Mixin

      # Disable block length for DSL
      # rubocop:disable Metrics/BlockLength
      namespace 'work' do |ops|
        ops.register 'add_to_works' do
          Steps::AddToWorks.new
        end

        ops.register 'apply_attributes' do
          Steps::ApplyAttributes.new
        end

        ops.register 'apply_permission_template' do
          Steps::ApplyPermissionTemplate.new
        end

        ops.register 'cleanup_features' do
          Steps::CleanupFeatures.new
        end

        ops.register 'cleanup_trophies' do
          Steps::CleanupTrophies.new
        end

        ops.register 'destroy_file_sets' do
          Steps::DestroyFileSets.new
        end

        ops.register 'destroy_work' do
          Steps::DestroyWork.new
        end

        ops.register 'ensure_admin_set' do
          Steps::EnsureAdminSet.new
        end

        ops.register 'ensure_permission_template' do
          Steps::EnsurePermissionTemplate.new
        end

        ops.register 'save_work' do
          Steps::SaveWork.new
        end

        ops.register 'set_default_admin_set' do
          Steps::SetDefaultAdminSet.new
        end

        ops.register 'set_depositor' do
          Steps::SetDepositor.new
        end

        ops.register 'set_modified_date' do
          Steps::SetModifiedDate.new
        end

        ops.register 'set_uploaded_date' do
          Steps::SetUploadedDate.new
        end
        # rubocop:enable Metrics/BlockLength
      end
    end
  end
end
