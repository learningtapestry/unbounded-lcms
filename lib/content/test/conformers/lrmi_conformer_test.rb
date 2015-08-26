require 'content/test/test_helper'
require 'content/conformers/lr_lrmi_conformer'

module Content
  module Test
    class LrLrmiConformerTest < ContentTestBase

      def test_document_doc_created_at
        assert_equal '1999-01-01', @doc.doc_created_at.strftime('%Y-%m-%d')
      end

      def test_document_description
        assert_equal 'This Java applet', @doc.description[0..15]
      end

      def test_document_title
        assert_equal 'Turtle Pond', @doc.title
      end

      def test_document_resource_locator
        assert_equal(
          'http://illuminations.nctm.org/Activity.aspx?id=3534',
          @doc.url.url
        )
      end

      def test_document_languages
        assert_equal ['en'], @doc.languages.map(&:name)
      end

      def test_document_resource_types
        assert_equal(
          [ 'activity', 'instructional material', 'interactive simulation'],
          @doc.resource_types.map(&:name).sort
        )
      end

      def test_document_alignments_size
        assert_equal 18, @doc.alignments.size
      end

      def test_document_alignments_content
        assert @doc.alignments.any? { |alignment|
          alignment.name == "CCSS.Math.Practice.MP1" &&
          alignment.framework == "Common Core State Standards for Mathematics" &&
          alignment.framework_url == "http://asn.jesandco.org/resources/S2366906"
        }
      end

      def test_document_subjects_size
        assert_equal 37, @doc.subjects.size
      end

      def test_document_subjects_content
        assert_includes @doc.subjects.map(&:name), 'angles'
      end

      def test_document_ignores_subjects
        refute @doc.subjects.map(&:name).any? { |kw| kw.start_with?('oai:nsdl.org') }
      end

      def test_document_age_ranges
        normalized = @doc.normalized_age_range
        assert_equal(
          [6, 16, true], [normalized[:min], normalized[:max], normalized[:extended]]
        )
      end

      def test_document_own_identities
        document_identities = @doc.document_identities.map { |idt| [idt.identity_type, idt.identity.name] }
        expected_identities = [
          ["curator", "Mathlanding: Elementary Mathematics Pathway"],
          ["submitter", "National Science Digital Library (NSDL)<nsdlsupport@nsdl.ucar.edu>"]
        ]
        assert_equal(expected_identities, document_identities)
      end

      def test_document_own_identities_ignores_submitter_type
        refute @doc.document_identities.any? { |idt| idt.identity_type == 'submitter_type' }
      end

      def test_document_lr_document
        assert_equal @lr_doc, @doc.source_document.document
      end

      def create_lr_document
        LrDocument.create(
          doc_id: 1,
          active: true,
          doc_type: 'resource_data',
          doc_version: '0.49.0',
          payload_placement: 'inline',
          resource_data_type: 'metadata',
          resource_locator: 'http://illuminations.nctm.org/Activity.aspx?id=3534',
          raw_data: ("{\"_id\":\"8aeb6d3753f64dc39c59a9a6f88abb38\",\"_rev\":\"1-1b1b3244f5abf524151e90649cb28491\",\"doc_type\":\"resource_data\",\"digital_signature\":{\"key_location\":[\"http://pool.sks-keyservers.net:11371/pks/lookup?op=get&fingerprint=on&search=0x51FAAF9F2067F0CE\"],\"key_owner\":\"National Science Digital Library (NSDL) <nsdlpersona@nsdl.ucar.edu>\",\"signing_method\":\"LR-PGP.1.0\",\"signature\":\"-----BEGIN PGP SIGNED MESSAGE-----\\nHash: SHA1\\n\\n7c70786683ec2a5825d009ca00d23a2d3ccbb19e9711f3e6d5c7bfc60e4f6963\\n-----BEGIN PGP SIGNATURE-----\\nVersion: GnuPG v1.4.5 (GNU/Linux)\\n\\niD8DBQFT3RGKUfqvnyBn8M4RAgT+AJ9Y0UdNNZto9n+G2Xw/fKPY7oRrowCgmIs2\\ng/AMkg5DSgO1V4UdFeR+fAU=\\n=nPYy\\n-----END PGP SIGNATURE-----\\n\"},\"resource_data\":{\"inLanguage\":[\"en\"],\"about\":[\"Angles\",\"Lines and planes\",\"Geometry\",\"Plane geometry\",\"Transformations\",\"Angle measure\",\"Length\",\"Scale\",\"Measurement\",\"Systems of measurement\",\"Nonstandard\",\"Analyze and persevere\",\"Reason quantitatively\",\"Practice Standards\",\"Attend to precision\",\"Concept formation\",\"Connections\",\"Estimation\",\"Problem solving\",\"Strategies\",\"Representation\",\"Visual representation\",\"Spatial sense\",\"Process skills\",\"Visualization\",\"Mathematics\",\"Physics\",\"Education\"],\"description\":[\"This Java applet provides opportunities for creative problem solving while encouraging young students to estimate length and angle measure. Using the Turtle Pond Applet, students enter a sequence of commands to help the turtle get to the pond. Children can write their own solutions using LOGO commands and input them into the computer. The turtle will then move and leave a trail or path according to the instructions given. (N.B. the applet is an upgrade of one that supported the Lesson \\\"Get the Turtle to the Pond,\\\" cataloged separately.)\"],\"publisher\":[{\"name\":\"National Council of Teachers of Mathematics\"}],\"educationalAlignment\":[{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"relate ideas in geometry to ideas in number and measurement\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S100EC5C\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"solve problems that arise in mathematics and in other contexts\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S101B385\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"understand such attributes as length, area, weight, volume, and size of angle and select the appropriate type of unit for measuring each attribute\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S101C299\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"find and name locations with simple relationships such as \\\"near to\\\" and in coordinate systems such as maps\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S1013C3D\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"develop common referents for measures to make comparisons and estimates\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S10254E5\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"create and describe mental images of objects, patterns, and paths\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S100F028\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"recognize and apply mathematics in contexts outside of mathematics\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S10019BC\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"describe, name, and interpret direction and distance in navigating space and apply ideas about direction and distance\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S10101F5\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"build new mathematical knowledge through problem solving\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S1012E71\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"understand how to measure using nonstandard and standard units\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S100A83B\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"describe locations and movement using common language and geometric vocabulary\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S1004B32\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"recognize and apply slides, flips, and turns\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S100EC2C\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"predict and describe the results of sliding, flipping, and turning two-dimensional shapes\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S1018F17\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"recognize and use connections among mathematical ideas\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S10253B3\"]},{\"educationalFramework\":[\"Principles and Standards for School Mathematics\"],\"targetDescription\":[\"apply and adapt a variety of appropriate strategies to solve problems\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S10120CF\"]},{\"educationalFramework\":[\"Common Core State Standards for Mathematics\"],\"targetName\":[\"CCSS.Math.Practice.MP1\"],\"targetDescription\":[\"Make sense of problems and persevere in solving them.\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S2366906\",\"http://corestandards.org/Math/Practice/MP1\"]},{\"educationalFramework\":[\"Common Core State Standards for Mathematics\"],\"targetName\":[\"CCSS.Math.Practice.MP2\"],\"targetDescription\":[\"Reason abstractly and quantitatively.\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S2366907\",\"http://corestandards.org/Math/Practice/MP2\"]},{\"educationalFramework\":[\"Common Core State Standards for Mathematics\"],\"targetName\":[\"CCSS.Math.Practice.MP6\"],\"targetDescription\":[\"Attend to precision.\"],\"targetUrl\":[\"http://asn.jesandco.org/resources/S2366911\",\"http://corestandards.org/Math/Practice/MP6\"]}],\"author\":[{\"name\":\"L.O. Cannon, et. al. (Utah State U.)\"}],\"encodings\":[{\"name\":\"application\"}],\"learningResourceType\":[\"Instructional Material\",\"Activity\",\"Interactive Simulation\"],\"dateCreated\":[\"1999-01-01\"],\"url\":\"http://illuminations.nctm.org/Activity.aspx?id=3534\",\"audience\":[{\"educationalRole\":\"Informal Education\",\"@type\":\"@EducationalAudience\"}],\"typicalAgeRange\":[\"6-11\",\"6-8\",\"7\",\"8-11\",\"8\",\"9\",\"10\",\"16+\"],\"@context\":[{\"url\":{\"@type\":\"@id\"},\"audience\":{\"@id\":\"audience\",\"@type\":\"@EducationalAudience\"},\"@vocab\":\"http://schema.org/\"},{\"lrmi\":\"http://lrmi.net/the-specification#\",\"useRightsUrl\":{\"@id\":\"lrmi:useRightsUrl\",\"@type\":\"@id\"}}],\"useRightsURL\":[\"http://illuminations.nctm.org/termsofuse.aspx\"],\"@id\":\"oai:nsdl.org:2200/20140728160921636T\",\"@type\":\"CreativeWork\",\"name\":[\"Turtle Pond\"]},\"keys\":[\"Grade 2\",\"Visualization\",\"Scale\",\"NSDL\",\"Grade 4\",\"Grade 3\",\"Early Elementary\",\"Spatial sense\",\"Visual representation\",\"Strategies\",\"Mathematics\",\"Analyze and persevere\",\"Concept formation\",\"oai:nsdl.org:2200/20140728160921636T\",\"Upper Elementary\",\"Grade 5\",\"Attend to precision\",\"Lines and planes\",\"Angle measure\",\"Angles\",\"Transformations\",\"Plane geometry\",\"Informal Education\",\"NSDL_SetSpec_ncs-NSDL-COLLECTION-000-003-112-027\",\"Geometry\",\"Practice Standards\",\"Length\",\"Elementary School\",\"Reason quantitatively\",\"Estimation\",\"Physics\",\"Systems of measurement\",\"Connections\",\"Problem solving\",\"Measurement\",\"Process skills\",\"Education\",\"Nonstandard\",\"Representation\"],\"TOS\":{\"submission_attribution\":\"The National Science Digital Library(NSDL) and its network of partners.\",\"submission_TOS\":\"http://nsdl.org/help/terms-of-use\"},\"resource_data_type\":\"metadata\",\"payload_placement\":\"inline\",\"payload_schema\":[\"LRMI\",\"JSON-LD\"],\"node_timestamp\":\"2014-08-02T16:27:59.395256Z\",\"doc_version\":\"0.49.0\",\"create_timestamp\":\"2014-08-02T16:27:59.395256Z\",\"update_timestamp\":\"2014-08-02T16:27:59.395256Z\",\"active\":true,\"publishing_node\":\"bf3e2bf1e40e4b9db68325fa4269b55b\",\"resource_locator\":\"http://illuminations.nctm.org/Activity.aspx?id=3534\",\"doc_ID\":\"8aeb6d3753f64dc39c59a9a6f88abb38\",\"identity\":{\"submitter\":\"National Science Digital Library (NSDL)<nsdlsupport@nsdl.ucar.edu>\",\"submitter_type\":\"agent\",\"curator\":\"Mathlanding: Elementary Mathematics Pathway\"}}"),
          resource_data_json: ({"inLanguage"=>["en"], "about"=>["Angles", "Lines and planes", "Geometry", "Plane geometry", "Transformations", "Angle measure", "Length", "Scale", "Measurement", "Systems of measurement", "Nonstandard", "Analyze and persevere", "Reason quantitatively", "Practice Standards", "Attend to precision", "Concept formation", "Connections", "Estimation", "Problem solving", "Strategies", "Representation", "Visual representation", "Spatial sense", "Process skills", "Visualization", "Mathematics", "Physics", "Education"], "description"=>["This Java applet provides opportunities for creative problem solving while encouraging young students to estimate length and angle measure. Using the Turtle Pond Applet, students enter a sequence of commands to help the turtle get to the pond. Children can write their own solutions using LOGO commands and input them into the computer. The turtle will then move and leave a trail or path according to the instructions given. (N.B. the applet is an upgrade of one that supported the Lesson \"Get the Turtle to the Pond,\" cataloged separately.)"], "publisher"=>[{"name"=>"National Council of Teachers of Mathematics"}], "educationalAlignment"=>[{"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["relate ideas in geometry to ideas in number and measurement"], "targetUrl"=>["http://asn.jesandco.org/resources/S100EC5C"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["solve problems that arise in mathematics and in other contexts"], "targetUrl"=>["http://asn.jesandco.org/resources/S101B385"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["understand such attributes as length, area, weight, volume, and size of angle and select the appropriate type of unit for measuring each attribute"], "targetUrl"=>["http://asn.jesandco.org/resources/S101C299"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["find and name locations with simple relationships such as \"near to\" and in coordinate systems such as maps"], "targetUrl"=>["http://asn.jesandco.org/resources/S1013C3D"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["develop common referents for measures to make comparisons and estimates"], "targetUrl"=>["http://asn.jesandco.org/resources/S10254E5"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["create and describe mental images of objects, patterns, and paths"], "targetUrl"=>["http://asn.jesandco.org/resources/S100F028"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["recognize and apply mathematics in contexts outside of mathematics"], "targetUrl"=>["http://asn.jesandco.org/resources/S10019BC"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["describe, name, and interpret direction and distance in navigating space and apply ideas about direction and distance"], "targetUrl"=>["http://asn.jesandco.org/resources/S10101F5"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["build new mathematical knowledge through problem solving"], "targetUrl"=>["http://asn.jesandco.org/resources/S1012E71"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["understand how to measure using nonstandard and standard units"], "targetUrl"=>["http://asn.jesandco.org/resources/S100A83B"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["describe locations and movement using common language and geometric vocabulary"], "targetUrl"=>["http://asn.jesandco.org/resources/S1004B32"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["recognize and apply slides, flips, and turns"], "targetUrl"=>["http://asn.jesandco.org/resources/S100EC2C"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["predict and describe the results of sliding, flipping, and turning two-dimensional shapes"], "targetUrl"=>["http://asn.jesandco.org/resources/S1018F17"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["recognize and use connections among mathematical ideas"], "targetUrl"=>["http://asn.jesandco.org/resources/S10253B3"]}, {"educationalFramework"=>["Principles and Standards for School Mathematics"], "targetDescription"=>["apply and adapt a variety of appropriate strategies to solve problems"], "targetUrl"=>["http://asn.jesandco.org/resources/S10120CF"]}, {"educationalFramework"=>["Common Core State Standards for Mathematics"], "targetName"=>["CCSS.Math.Practice.MP1"], "targetDescription"=>["Make sense of problems and persevere in solving them."], "targetUrl"=>["http://asn.jesandco.org/resources/S2366906", "http://corestandards.org/Math/Practice/MP1"]}, {"educationalFramework"=>["Common Core State Standards for Mathematics"], "targetName"=>["CCSS.Math.Practice.MP2"], "targetDescription"=>["Reason abstractly and quantitatively."], "targetUrl"=>["http://asn.jesandco.org/resources/S2366907", "http://corestandards.org/Math/Practice/MP2"]}, {"educationalFramework"=>["Common Core State Standards for Mathematics"], "targetName"=>["CCSS.Math.Practice.MP6"], "targetDescription"=>["Attend to precision."], "targetUrl"=>["http://asn.jesandco.org/resources/S2366911", "http://corestandards.org/Math/Practice/MP6"]}], "author"=>[{"name"=>"L.O. Cannon, et. al. (Utah State U.)"}], "encodings"=>[{"name"=>"application"}], "learningResourceType"=>["Instructional Material", "Activity", "Interactive Simulation"], "dateCreated"=>["1999-01-01"], "url"=>"http://illuminations.nctm.org/Activity.aspx?id=3534", "audience"=>[{"educationalRole"=>"Informal Education", "@type"=>"@EducationalAudience"}], "typicalAgeRange"=>["6-11", "6-8", "7", "8-11", "8", "9", "10", "16+"], "@context"=>[{"url"=>{"@type"=>"@id"}, "audience"=>{"@id"=>"audience", "@type"=>"@EducationalAudience"}, "@vocab"=>"http://schema.org/"}, {"lrmi"=>"http://lrmi.net/the-specification#", "useRightsUrl"=>{"@id"=>"lrmi:useRightsUrl", "@type"=>"@id"}}], "useRightsURL"=>["http://illuminations.nctm.org/termsofuse.aspx"], "@id"=>"oai:nsdl.org:2200/20140728160921636T", "@type"=>"CreativeWork", "name"=>["Turtle Pond"]}),
          resource_data_xml: nil,
          resource_data_string: nil ,
          identity: ({"curator"=>"Mathlanding: Elementary Mathematics Pathway", "submitter"=>"National Science Digital Library (NSDL)<nsdlsupport@nsdl.ucar.edu>", "submitter_type"=>"agent"}),
          keys: (["Grade 2", "Visualization", "Scale", "NSDL", "Grade 4", "Grade 3", "Early Elementary", "Spatial sense", "Visual representation", "Strategies", "Mathematics", "Analyze and persevere", "Concept formation", "oai:nsdl.org:2200/20140728160921636T", "Upper Elementary", "Grade 5", "Attend to precision", "Lines and planes", "Angle measure", "Angles", "Transformations", "Plane geometry", "Informal Education", "NSDL_SetSpec_ncs-NSDL-COLLECTION-000-003-112-027", "Geometry", "Practice Standards", "Length", "Elementary School", "Reason quantitatively", "Estimation", "Physics", "Systems of measurement", "Connections", "Problem solving", "Measurement", "Process skills", "Education", "Nonstandard", "Representation"]),
          payload_schema: (["LRMI", "JSON-LD"]),
          format_parsed_at: nil
        ).tap do |lr_doc|
          lr_doc.source_document = Content::SourceDocument.new(source_type: 0)
          lr_doc.save
        end
      end

      def setup
        super
        @lr_doc = create_lr_document
        @doc = Conformers::LrLrmiConformer.new(@lr_doc).conform!
      end
    end
  end
end
