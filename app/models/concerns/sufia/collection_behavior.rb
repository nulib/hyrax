module Sufia
  module CollectionBehavior
    extend ActiveSupport::Concern
    include Hydra::AccessControls::WithAccessRight
    include Hydra::WithDepositor # for access to apply_depositor_metadata
    include Hydra::AccessControls::Permissions
    include Sufia::RequiredMetadata
    include Hydra::Works::CollectionBehavior
    include Sufia::Noid
    include Sufia::HumanReadableType
    include Sufia::HasRepresentative
    include Sufia::Permissions

    included do
      validates_with HasOneTitleValidator
    end

    def add_members(new_member_ids)
      return if new_member_ids.nil? || new_member_ids.empty?
      members << ActiveFedora::Base.find(new_member_ids)
    end

    def to_s
      title.present? ? title.join(' | ') : 'No Title'
    end

    module ClassMethods
      def indexer
        Sufia::CollectionIndexer
      end
    end

    # Compute the sum of each file in the collection using Solr to
    # avoid having to access Fedora
    #
    # @return [Fixnum] size of collection in bytes
    # @raise [RuntimeError] unsaved record does not exist in solr
    def bytes
      return 0 if member_ids.count == 0

      raise "Collection must be saved to query for bytes" if new_record?

      # One query per member_id because Solr is not a relational database
      sizes = member_ids.collect do |work_id|
        argz = { fl: "id, #{file_size_field}",
                 fq: "{!join from=#{member_ids_field} to=id}id:#{work_id}"
        }
        files = ::FileSet.search_with_conditions({}, argz)
        files.reduce(0) { |sum, f| sum + f[file_size_field].to_i }
      end

      sizes.reduce(0, :+)
    end

    private

      # Field name to look up when locating the size of each file in Solr.
      # Override for your own installation if using something different
      def file_size_field
        Solrizer.solr_name(:file_size, Sufia::FileSetIndexer::STORED_INTEGER)
      end

      # Solr field name collections and works use to index member ids
      def member_ids_field
        Solrizer.solr_name('member_ids', :symbol)
      end
  end
end