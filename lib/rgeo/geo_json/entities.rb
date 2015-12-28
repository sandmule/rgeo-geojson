module RGeo
  module GeoJSON
    # This is a GeoJSON wrapper entity that corresponds to the GeoJSON
    # "Feature" type. It is an immutable type.
    #
    # This is the default implementation that is generated by
    # RGeo::GeoJSON::EntityFactory. You may replace this implementation
    # by writing your own entity factory. Note that an alternate Feature
    # implementation need not subclass or even duck-type this class.
    # the entity factory mediates all interaction between the GeoJSON
    # engine and features.

    class Feature
      # Create a feature wrapping the given geometry, with the given ID
      # and properties.

      def initialize(geometry_, id_ = nil, properties_ = {})
        @geometry = geometry_
        @id = id_
        @properties = {}
        properties_.each do |k_, v_|
          @properties[k_.to_s] = v_
        end
      end

      def inspect # :nodoc:
        "#<#{self.class}:0x#{object_id.to_s(16)} id=#{@id.inspect} geom=#{@geometry ? @geometry.as_text.inspect : 'nil'}>"
      end

      def to_s  # :nodoc:
        inspect
      end

      def hash  # :nodoc:
        @geometry.hash + @id.hash + @properties.hash
      end

      # Two features are equal if their geometries, IDs, and properties
      # are all equal.
      # This method uses the eql? method to test geometry equality, which
      # may behave differently than the == operator.

      def eql?(rhs_)
        rhs_.is_a?(Feature) && @geometry.eql?(rhs_.geometry) && @id.eql?(rhs_.feature_id) && @properties.eql?(rhs_.instance_variable_get(:@properties))
      end

      # Two features are equal if their geometries, IDs, and properties
      # are all equal.
      # This method uses the == operator to test geometry equality, which
      # may behave differently than the eql? method.

      def ==(rhs_)
        rhs_.is_a?(Feature) && @geometry == rhs_.geometry && @id == rhs_.feature_id && @properties == rhs_.instance_variable_get(:@properties)
      end

      # Returns the geometry contained in this feature, which may be nil.

      attr_reader :geometry

      # Returns the ID for this feature, which may be nil.

      def feature_id
        @id
      end

      # Returns a copy of the properties for this feature.

      def properties
        @properties.dup
      end

      # Gets the value of the given named property.
      # Returns nil if the given property is not found.

      def property(key_)
        @properties[key_.to_s]
      end
      alias_method :[], :property

      # Gets an array of the known property keys in this feature.

      def keys
        @properties.keys
      end
    end

    # This is a GeoJSON wrapper entity that corresponds to the GeoJSON
    # "FeatureCollection" type. It is an immutable type.
    #
    # This is the default implementation that is generated by
    # RGeo::GeoJSON::EntityFactory. You may replace this implementation
    # by writing your own entity factory. Note that an alternate
    # FeatureCollection implementation need not subclass or even
    # duck-type this class. The entity factory mediates all interaction
    # between the GeoJSON engine and feature collections.

    class FeatureCollection
      include ::Enumerable

      # Create a new FeatureCollection with the given features, which must
      # be provided as an Enumerable.

      def initialize(features_ = [])
        @features = []
        features_.each { |f_| @features << f_ if f_.is_a?(Feature) }
      end

      def inspect # :nodoc:
        "#<#{self.class}:0x#{object_id.to_s(16)}>"
      end

      def to_s  # :nodoc:
        inspect
      end

      def hash  # :nodoc:
        @features.hash
      end

      # Two feature collections are equal if they contain the same
      # features in the same order.
      # This methods uses the eql? method to test geometry equality, which
      # may behave differently than the == operator.

      def eql?(rhs_)
        rhs_.is_a?(FeatureCollection) && @features.eql?(rhs_.instance_variable_get(:@features))
      end

      # Two feature collections are equal if they contain the same
      # features in the same order.
      # This methods uses the == operator to test geometry equality, which
      # may behave differently than the eql? method.

      def ==(rhs_)
        rhs_.is_a?(FeatureCollection) && @features == rhs_.instance_variable_get(:@features)
      end

      # Iterates or returns an iterator for the features.

      def each(&block_)
        @features.each(&block_)
      end

      # Returns the number of features contained in this collection.

      def size
        @features.size
      end

      # Access a feature by index.

      def [](index_)
        @features[index_]
      end
    end

    # This is the default entity factory. It creates objects of type
    # RGeo::GeoJSON::Feature and RGeo::GeoJSON::FeatureCollection.
    # You may create your own entity factory by duck-typing this class.

    class EntityFactory
      # Create and return a new feature, given geometry, ID, and
      # properties hash. Note that, per the GeoJSON spec, geometry and/or
      # properties may be nil.

      def feature(geometry_, id_ = nil, properties_ = nil)
        Feature.new(geometry_, id_, properties_ || {})
      end

      # Create and return a new feature collection, given an enumerable
      # of feature objects.

      def feature_collection(features_ = [])
        FeatureCollection.new(features_)
      end

      # Returns true if the given object is a feature created by this
      # entity factory.

      def is_feature?(object_)
        object_.is_a?(Feature)
      end

      # Returns true if the given object is a feature collection created
      # by this entity factory.

      def is_feature_collection?(object_)
        object_.is_a?(FeatureCollection)
      end

      # Run Enumerable#map on the features contained in the given feature
      # collection.

      def map_feature_collection(object_, &block_)
        object_.map(&block_)
      end

      # Returns the geometry associated with the given feature.

      def get_feature_geometry(object_)
        object_.geometry
      end

      # Returns the ID of the given feature, or nil for no ID.

      def get_feature_id(object_)
        object_.feature_id
      end

      # Returns the properties of the given feature as a hash. Editing
      # this hash does not change the state of the feature.

      def get_feature_properties(object_)
        object_.properties
      end

      # Return the singleton instance of EntityFactory.

      def self.instance
        @instance ||= new
      end
    end
  end
end
