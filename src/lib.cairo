mod components {
    mod absorber {
        mod interface;
        mod module;
    }
    mod access {
        mod interface;
        mod module;
    }
    mod farm {
        mod interface;
        mod module;
    }
    mod offset {
        mod interface;
        mod module;
    }
    mod yield {
        mod interface;
        mod module;
    }
}

mod project;
mod offseter;
mod yielder;

#[cfg(test)]
mod tests {
    mod test_offseter;
    mod test_yielder;
}

