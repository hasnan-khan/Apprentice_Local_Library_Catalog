class Odata::V4::MetadataController < ApplicationController
  def show
    xml_content = <<-XML
<?xml version="1.0" encoding="utf-8"?>
<edmx:Edmx Version="4.0" xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx">
  <edmx:DataServices>
    <Schema Namespace="Library" xmlns="http://docs.oasis-open.org/odata/ns/edm">
      <EntityType Name="Book">
        <Key>
          <PropertyRef Name="id" />
        </Key>
        <Property Name="id" Type="Edm.Int32" Nullable="false" />
        <Property Name="title" Type="Edm.String" />
        <Property Name="author" Type="Edm.String" />
        <Property Name="genre" Type="Edm.String" />
        <Property Name="short_description" Type="Edm.String" />
        <Property Name="status" Type="Edm.String" />
      </EntityType>
      <EntityContainer Name="DefaultContainer">
        <EntitySet Name="books" EntityType="Library.Book" />
      </EntityContainer>
    </Schema>
  </edmx:DataServices>
</edmx:Edmx>
    XML

    render xml: xml_content, content_type: "application/xml"
  end
end
