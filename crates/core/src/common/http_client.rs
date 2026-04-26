use reqwest::{Client, RequestBuilder, Response};

#[derive(Debug, Clone)]
pub struct HttpClient {
    base_url: String,
    client: Client,
}

impl HttpClient {
    pub fn new(base_url: impl Into<String>, client: Client) -> Self {
        Self {
            base_url: base_url.into(),
            client,
        }
    }

    pub fn client(&self) -> &Client {
        &self.client
    }

    pub fn base_url(&self) -> &str {
        &self.base_url
    }

    pub fn join_url(&self, path: &str) -> String {
        format!("{}{}", self.base_url.trim_end_matches('/'), path)
    }

    pub fn post(&self, path: &str) -> RequestBuilder {
        self.client.post(self.join_url(path))
    }

    pub fn get(&self, path: &str) -> RequestBuilder {
        self.client.get(self.join_url(path))
    }

    pub async fn execute(&self, request: RequestBuilder) -> reqwest::Result<Response> {
        request.send().await
    }
}
