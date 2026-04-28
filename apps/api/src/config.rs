use worker::Env;

#[derive(Debug, Clone)]
pub struct ApiConfig {
    runtime_config_template: &'static str,
}

const CONFIG_YAML: &str = include_str!("../config.yaml");

impl Default for ApiConfig {
    fn default() -> Self {
        Self {
            runtime_config_template: CONFIG_YAML,
        }
    }
}

impl ApiConfig {
    pub fn render_runtime_config(&self, env: &Env) -> String {
        render_runtime_config(self.runtime_config_template, |key| {
            env.var(key).ok().map(|value| value.to_string())
        })
    }
}

fn render_runtime_config<F>(template: &str, lookup: F) -> String
where
    F: Fn(&str) -> Option<String>,
{
    let mut rendered = String::with_capacity(template.len());
    let mut chars = template.chars().peekable();

    while let Some(ch) = chars.next() {
        if ch == '$' && chars.peek() == Some(&'{') {
            chars.next();

            let mut key = String::new();
            while let Some(&next) = chars.peek() {
                chars.next();
                if next == '}' {
                    break;
                }
                key.push(next);
            }

            if key.is_empty() {
                rendered.push_str("null");
            } else if let Some(value) = lookup(&key) {
                rendered.push_str(&value);
            } else {
                rendered.push_str("null");
            }

            continue;
        }

        rendered.push(ch);
    }

    rendered
}

#[cfg(test)]
mod tests {
    use super::render_runtime_config;

    #[test]
    fn replaces_placeholders_with_values() {
        let rendered = render_runtime_config("a: ${FOO}\nb: ${BAR}", |key| match key {
            "FOO" => Some("hello".to_owned()),
            _ => None,
        });

        assert_eq!(rendered, "a: hello\nb: null");
    }
}
