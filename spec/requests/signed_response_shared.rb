shared_examples "signed response" do
  it "is correctly signed" do
    request
    expect(response.headers.keys).to include(
      "date",
      "content-digest",
      "signature-input",
      "signature"
    )
  end
end
