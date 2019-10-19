import { ApolloServer, gql, PubSub } from 'apollo-server'
import { Connection, createConnection, EntityManager } from 'typeorm'

import { Book } from './entity/Book'

const typeDefs = gql`
  type Book {
    id: String!
    title: String!
    author: String!
  }

  type Query {
    books: [Book!]!
  }

  input CreateBookInput {
    title: String!
    author: String!
  }

  type Mutation {
    createBook(data: CreateBookInput!): Book!
  }

  type Subscription {
    bookAdded: Book!
  }
`

enum Label {
  BOOK_ADDED = 'BOOK_ADDED',
}

const pubsub = new PubSub()

const resolvers = {
  Book: {
    id: (parent) => parent.id.toString(),
  },
  Query: {
    books: (_parent, _args, { connection }: IContext) => {
      return connection.manager.find(Book)
    },
  },
  Mutation: {
    async createBook(_parent, args: any, { connection }: IContext) {
      const entity = connection.manager.create(Book, args.data)
      const book = await connection.manager.save(entity)
      pubsub.publish(Label.BOOK_ADDED, { bookAdded: book })
      return book
    },
  },
  Subscription: {
    bookAdded: {
      subscribe: () => pubsub.asyncIterator([Label.BOOK_ADDED]),
    },
  },
}

interface IContext {
  connection: Connection
}

async function populate(manager: EntityManager) {
  const count = await manager.count(Book)
  if (count > 0) {
    return
  }
  const { raw } = await manager.insert(Book, [
    {
      title: 'Harry Potter and the Chamber of Secrets',
      author: 'J.K. Rowling',
    },
    {
      title: 'Jurassic Park',
      author: 'Michael Crichton',
    },
  ])
  console.info('[mongo]:', raw.ops)
}

async function run() {
  const connection = await createConnection()
  const context: IContext = { connection }
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context,
  })

  await populate(connection.manager)
  const { url } = await server.listen()
  console.log(`🚀  Server ready at ${url}`)
}

run()
