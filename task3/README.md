# project workflow

## prerequisite
- clone the repos
- install helm
- install istioctl
- make sure kubernetes configuration works

## create the space
kubectl apply -f kubernetes/dicoding-namespace.yml

## configure istio
istioctl install --set profile=demo -y
kubectl label namespace dicoding istio-injection=enabled

## deploy rabbitmq using helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-rabbitmq bitnami/rabbitmq

## rabbitmq credentials
echo "Username      : user"
echo "Password      : $(kubectl get secret --namespace dicoding my-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
echo "ErLang Cookie : $(kubectl get secret --namespace dicoding my-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"

## rabbitmq amqp access
echo "URL : amqp://127.0.0.1:5672/"
kubectl port-forward --namespace dicoding svc/my-rabbitmq 5672:5672

## rabbitmq management access
echo "URL : http://127.0.0.1:15672/"
kubectl port-forward --namespace dicoding svc/my-rabbitmq 15672:15672

## verify that rabbitmq is running
kubectl get pods -n dicoding -l app.kubernetes.io/instance=my-rabbitmq

## build and push project images
./shipping-service/build_push_image.sh
./order-service/build_push_image.sh

## deploy and verify shipping service
kubectl apply -f kubernetes/shipping-service/
kubectl logs $(kubectl get pods -n dicoding -l app=shipping-service -o jsonpath="{.items[0].metadata.name}") -n dicoding

## deploy and verify order service
kubectl apply -f kubernetes/order-service/
kubectl logs $(kubectl get pods -n dicoding -l app=order-service -o jsonpath="{.items[0].metadata.name}") -n dicoding

## test
kubectl port-forward svc/istio-ingressgateway -n istio-system 80:80
curl -X POST -H "Content-Type: application/json" -d '{
    "order": {
        "book_name": "Harry Potter",
        "author": "J.K Rowling",
        "buyer": "Fikri Helmi Setiawan",
        "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
    }
}' http://127.0.0.1:80/order

## verify responses
kubectl logs $(kubectl get pods -n dicoding -l app=shipping-service -o jsonpath="{.items[0].metadata.name}") -n dicoding
kubectl logs $(kubectl get pods -n dicoding -l app=order-service -o jsonpath="{.items[0].metadata.name}") -n dicoding
