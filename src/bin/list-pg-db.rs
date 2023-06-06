use clap::Parser;
use postgres::{Client, NoTls};

#[derive(Parser)]
struct Opts {
    #[clap(short, long)]
    dsn: String,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let opts: Opts = Opts::parse();

    let mut client = Client::connect(opts.dsn.as_ref(), NoTls)?;
    let rows = client.query("SELECT datname FROM pg_database", &[])?;
    for row in rows {
        let db_name: String = row.get(0);
        println!("{}", db_name);
    }
    Ok(())
}
