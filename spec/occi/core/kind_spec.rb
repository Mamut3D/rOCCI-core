module Occi
  module Core
    describe Kind do

      describe '#get_class' do

        it 'gets OCCI Resource class by term and scheme' do
          scheme = 'http://schemas.ogf.org/occi/core'
          term = 'resource'
          klass = Occi::Core::Kind.get_class scheme, term
          klass.should be Occi::Core::Resource
          klass.superclass.should be Occi::Core::Entity
        end

        it 'gets non predefined OCCI class by term, scheme and related class' do
          scheme = 'http://example.com/occi'
          term = 'test'
          related = ['http://schemas.ogf.org/occi/core#resource']
          klass = Occi::Core::Kind.get_class scheme, term, related
          klass.should be Com::Example::Occi::Test
          klass.superclass.should be Occi::Core::Resource
        end

        it 'does not get OCCI class by term and scheme if it relates to existing class not derived from OCCI Entity' do
          scheme = 'http://hashie/'
          term = 'mash'
          related = ['http://schemas.ogf.org/occi/core#resource']
          expect { Occi::Core::Kind.get_class scheme, term, related }.to raise_error
        end

      end

      describe '#related_to?' do
        kind = Occi::Core::Kind.new
        parent_kind = Occi::Core::Kind.new
        unrelated = Occi::Core::Kind.new
        kind.parent = parent_kind

        it 'relates to parent' do
          expect(kind.related_to?(parent_kind)).to eq true
	end

        it 'is related to by parent' do
          expect(parent_kind.related_to?(kind)).to eq true
	end

        it 'does not relate to unrelated object' do
          expect(kind.related_to?(unrelated)).to eq false
        end

#	TODO: create empty kind instances, create relations and then check related_to()

      end

      describe '#as_json' do
        kind = Occi::Core::Kind.new

        it 'renders JSON correctly from freshly initialized object' do
	  expected = '{"location":"/kind/","term":"kind","scheme":"http://schemas.ogf.org/occi/core#"}'
	  hash=Hashie::Mash.new(JSON.parse(expected))
	  expect(kind.as_json).to eql(hash)
        end

        it 'renders JSON correctly with optional attributes' do
	  kind.title = "test title"
	  expected = '{"location":"/kind/","term":"kind","scheme":"http://schemas.ogf.org/occi/core#","title":"test title"}'
	  hash=Hashie::Mash.new(JSON.parse(expected))
	  expect(kind.as_json).to eql(hash)
        end

#	TODO: Optional attributes, special characters

        it 'renders JSON correctly with special characters' do
	  kind.title = "Some special characters @#\$%"
	  expected = '{"location":"/kind/","term":"kind","scheme":"http://schemas.ogf.org/occi/core#","title":"Some special characters @#\$%"}'
	  hash=Hashie::Mash.new(JSON.parse(expected))
	  expect(kind.as_json).to eql(hash)
        end

      end

      describe '#to_string' do
        kind = Occi::Core::Kind.new

        it 'produces a string correctly from freshly initialized object' do
	  expected = ('scheme="http://schemas.ogf.org/occi/core#";class="kind";location="/kind/";kind').split(/;/)
	  actual = kind.to_string.split(/;/)
	  expect(actual).to match_array(expected)
        end

        it 'produces a string correctly with optional attributes' do
	  kind.title = "test title"
	  expected = ('scheme="http://schemas.ogf.org/occi/core#";class="kind";location="/kind/";kind;title="test title"').split(/;/)
	  actual = kind.to_string.split(/;/)
	  expect(actual).to match_array(expected)
        end

#	TODO: Optional attributes, special characters

      end

    end
  end
end
