import { Construct } from "constructs";
import { App, TerraformStack, TerraformOutput, RemoteBackend } from "cdktf";
import { AwsProvider, ec2 } from "@cdktf/provider-aws";

class MyStack extends TerraformStack {
    constructor(scope: Construct, id: string) {
      super(scope, id);
  
      new AwsProvider(this, "AWS", {
        region: "us-east-1",
      });
  
      const instance = new ecs.Instance(this, "pyliquid", { 
        name: "pyliquid-server",
      });
  
      new TerraformOutput(this, "public_ip", {
        value: instance.publicIp,
      });
    }
  }
  
  const app = new App();
  const stack = new MyStack(app, "aws_instance");
  
  new RemoteBackend(stack, {
    hostname: "app.terraform.io",
    organization: "<YOUR_ORG>",
    workspaces: {
      name: "learn-cdktf",
    },
  });
  
  app.synth();